import fs from "node:fs";
import path from "node:path";
import { chromium, request } from "playwright";

const workspaceRoot =
  process.env.WORKSPACE_ROOT || path.resolve(process.cwd(), "..", "..");
const reportDir = path.join(workspaceRoot, "report");
const screenshotDir = path.join(reportDir, "答辩截图");

const backendUrl = process.env.BACKEND_URL || "http://127.0.0.1:8080";
const frontendUrl = process.env.FRONTEND_URL || "http://127.0.0.1:5173";
const clientId = process.env.CLIENT_ID || "e5cd7e4891bf95d1d19206ce24a7b32e";
const adminUser = process.env.ADMIN_USER || "admin";
const adminPassword = process.env.ADMIN_PASSWORD || "admin123";

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function safeGoto(page, url) {
  for (let i = 0; i < 2; i += 1) {
    try {
      await page.goto(url, { waitUntil: "commit", timeout: 120000 });
      return;
    } catch (err) {
      if (i === 1) {
        throw err;
      }
      await sleep(1500);
    }
  }
}

async function waitForContent(page, minChars = 30, timeoutMs = 45000) {
  try {
    await page.waitForFunction(
      (min) => {
        const text = (document.body && document.body.innerText) || "";
        return text.replace(/\s+/g, "").length >= min;
      },
      minChars,
      { timeout: timeoutMs }
    );
    return true;
  } catch (_e) {
    return false;
  }
}

async function captureFullPage(page, filePath) {
  const cdp = await page.context().newCDPSession(page);
  try {
    const size = await page.evaluate(() => {
      const body = document.body;
      const doc = document.documentElement;
      const width = Math.max(
        body ? body.scrollWidth : 0,
        doc ? doc.scrollWidth : 0,
        window.innerWidth || 0
      );
      const height = Math.max(
        body ? body.scrollHeight : 0,
        doc ? doc.scrollHeight : 0,
        window.innerHeight || 0
      );
      return { width, height };
    });

    const width = Math.max(1280, Math.ceil(size.width || 1280));
    const height = Math.max(800, Math.ceil(size.height || 800));

    await cdp.send("Emulation.setDeviceMetricsOverride", {
      mobile: false,
      width,
      height,
      deviceScaleFactor: 1,
      screenWidth: width,
      screenHeight: height,
    });

    const shot = await cdp.send("Page.captureScreenshot", {
      format: "png",
      fromSurface: true,
      captureBeyondViewport: true,
    });
    fs.writeFileSync(filePath, Buffer.from(shot.data, "base64"));
  } finally {
    try {
      await cdp.send("Emulation.clearDeviceMetricsOverride");
    } catch (_e) {
      // ignore
    }
    try {
      await cdp.detach();
    } catch (_e) {
      // ignore
    }
  }
}

function ensureScreenshotDir() {
  fs.mkdirSync(screenshotDir, { recursive: true });
}

function latestAcceptanceReport() {
  if (!fs.existsSync(reportDir)) {
    return null;
  }
  const files = fs
    .readdirSync(reportDir)
    .filter((name) => /^acceptance-report-.*\.md$/i.test(name))
    .map((name) => {
      const full = path.join(reportDir, name);
      return { name, full, mtime: fs.statSync(full).mtimeMs };
    })
    .sort((a, b) => b.mtime - a.mtime);
  return files.length > 0 ? files[0] : null;
}

async function loginToken() {
  const api = await request.newContext({
    baseURL: backendUrl,
    extraHTTPHeaders: {
      clientid: clientId,
    },
  });
  try {
    const resp = await api.post("/auth/login", {
      data: {
        clientId,
        grantType: "password",
        tenantId: "000000",
        username: adminUser,
        password: adminPassword,
      },
    });
    const data = await resp.json().catch(() => null);
    if (!resp.ok() || data?.code !== 200 || !data?.data?.access_token) {
      const msg = data?.msg || `status=${resp.status()}`;
      throw new Error(`auth/login failed: ${msg}`);
    }
    return data.data.access_token;
  } finally {
    await api.dispose();
  }
}

async function firstHomestayId() {
  const api = await request.newContext({ baseURL: backendUrl });
  try {
    const resp = await api.get("/api/homestay/list?pageNum=1&pageSize=1");
    if (!resp.ok()) {
      return "1";
    }
    const data = await resp.json().catch(() => null);
    const row = Array.isArray(data?.rows) ? data.rows[0] : null;
    const id = row?.id || row?.thingId || row?.homestayId || 1;
    return String(id);
  } finally {
    await api.dispose();
  }
}

async function capture() {
  ensureScreenshotDir();

  const token = await loginToken();
  const homestayId = await firstHomestayId();

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: { width: 1440, height: 900 },
  });
  const page = await context.newPage();
  page.setDefaultNavigationTimeout(120000);

  await page.addInitScript((t) => {
    localStorage.setItem("admin_user_token", t);
    localStorage.setItem("admin_user_id", "1");
    localStorage.setItem("admin_user_name", "admin");
    localStorage.setItem("user_token", t);
    localStorage.setItem("user_id", "1");
    localStorage.setItem("user_name", "admin");
  }, token);

  const shots = [
    { url: `${frontendUrl}/index/portal`, file: "01-home-list.png", wait: 2200, minChars: 80, minBytes: 12000 },
    { url: `${frontendUrl}/index/detail?id=${homestayId}`, file: "02-home-detail.png", wait: 2500, minChars: 60, minBytes: 10000 },
    { url: `${frontendUrl}/index/usercenter/orderView`, file: "03-tenant-order.png", wait: 2200, minChars: 60, minBytes: 20000 },
    { url: `${frontendUrl}/admin/order`, file: "04-landlord-order-action.png", wait: 2200, minChars: 60, minBytes: 20000 },
    { url: `${frontendUrl}/admin/overview`, file: "05-admin-overview.png", wait: 2200, minChars: 60, minBytes: 20000 },
    { url: `${frontendUrl}/admin/supervision`, file: "06-admin-supervision.png", wait: 2600, minChars: 60, minBytes: 20000 },
  ];

  for (const item of shots) {
    const target = path.join(screenshotDir, item.file);
    let captured = false;
    for (let i = 0; i < 2; i += 1) {
      await safeGoto(page, item.url);
      await sleep(item.wait + i * 1200);
      await waitForContent(page, item.minChars, 20000 + i * 8000);
      await captureFullPage(page, target);
      const size = fs.existsSync(target) ? fs.statSync(target).size : 0;
      if (size >= item.minBytes) {
        captured = true;
        break;
      }
    }
    if (!captured) {
      console.warn(`screenshot may be incomplete: ${item.file}`);
    }
  }

  await safeGoto(page, `${frontendUrl}/admin/supervision`);
  await sleep(1600);
  try {
    const generateBtn = page.getByRole("button", { name: "自动生成" });
    const processBtn = page.getByRole("button", { name: "处理待上报" });
    if (await generateBtn.count()) {
      await generateBtn.first().click();
      await sleep(1800);
    }
    if (await processBtn.count()) {
      await processBtn.first().click();
      await sleep(2200);
    }
  } catch (_e) {
    // Keep capture flow stable even if button interaction fails.
  }
  const shot07 = path.join(screenshotDir, "07-admin-supervision-success.png");
  let ok07 = false;
  for (let i = 0; i < 2; i += 1) {
    await waitForContent(page, 60, 18000 + i * 8000);
    await captureFullPage(page, shot07);
    const size = fs.existsSync(shot07) ? fs.statSync(shot07).size : 0;
    if (size >= 20000) {
      ok07 = true;
      break;
    }
    await sleep(1200);
  }
  if (!ok07) {
    console.warn("screenshot may be incomplete: 07-admin-supervision-success.png");
  }

  const latest = latestAcceptanceReport();
  const reportName = latest ? latest.name : "N/A";
  const reportText = latest
    ? fs.readFileSync(latest.full, "utf8")
    : "No acceptance report found.";
  const escaped = reportText
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");

  await page.setContent(
    `
      <html>
        <head><meta charset="utf-8"><title>Acceptance Report</title></head>
        <body style="margin:24px;background:#f6f8fa;font-family:Consolas,'Courier New',monospace;">
          <h2>Latest Acceptance Report: ${reportName}</h2>
          <pre style="background:#fff;border:1px solid #ddd;padding:16px;white-space:pre-wrap;">${escaped}</pre>
        </body>
      </html>
    `,
    { waitUntil: "domcontentloaded" }
  );
  await sleep(500);
  const shot08 = path.join(screenshotDir, "08-acceptance-report-pass.png");
  await captureFullPage(page, shot08);

  await browser.close();
}

capture()
  .then(() => {
    console.log(`Real screenshots captured at: ${screenshotDir}`);
  })
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
