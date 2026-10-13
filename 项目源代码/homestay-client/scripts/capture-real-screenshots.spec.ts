import { test } from "@playwright/test";
import fs from "node:fs";
import path from "node:path";

const workspaceRoot = process.env.WORKSPACE_ROOT || path.resolve(process.cwd(), "..", "..");
const reportDir = path.join(workspaceRoot, "report");
const frontendUrl = process.env.FRONTEND_URL || "http://127.0.0.1:5173";

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function findScreenshotDir(): string {
  const stack = [reportDir];
  while (stack.length > 0) {
    const cur = stack.pop() as string;
    const entries = fs.readdirSync(cur, { withFileTypes: true });
    for (const entry of entries) {
      const full = path.join(cur, entry.name);
      if (entry.isDirectory()) {
        stack.push(full);
      }
      if (entry.isFile() && entry.name.toLowerCase() === "readme.md") {
        return path.dirname(full);
      }
    }
  }
  const fallback = path.join(reportDir, "答辩截图");
  fs.mkdirSync(fallback, { recursive: true });
  return fallback;
}

test("capture-real-screenshots", async ({ page }) => {
  const screenshotDir = findScreenshotDir();
  const token = "demo-token";
  const homestayId = "1";

  await page.setViewportSize({ width: 1440, height: 900 });
  await page.goto(`${frontendUrl}/index/portal`, { waitUntil: "domcontentloaded" });
  await page.evaluate((t) => {
    localStorage.setItem("admin_user_token", t);
    localStorage.setItem("admin_user_id", "1");
    localStorage.setItem("admin_user_name", "admin");
    localStorage.setItem("user_token", t);
    localStorage.setItem("user_id", "1");
    localStorage.setItem("user_name", "admin");
  }, token);

  const shots = [
    { url: `${frontendUrl}/index/portal`, file: "01-home-list.png", wait: 1600 },
    { url: `${frontendUrl}/index/detail?id=${homestayId}`, file: "02-home-detail.png", wait: 2000 },
    { url: `${frontendUrl}/index/usercenter/orderView`, file: "03-tenant-order.png", wait: 1800 },
    { url: `${frontendUrl}/admin/order`, file: "04-landlord-order-action.png", wait: 1800 },
    { url: `${frontendUrl}/admin/overview`, file: "05-admin-overview.png", wait: 1800 },
    { url: `${frontendUrl}/admin/supervision`, file: "06-admin-supervision.png", wait: 2200 },
  ];

  for (const item of shots) {
    await page.goto(item.url, { waitUntil: "domcontentloaded" });
    await sleep(item.wait);
    await page.screenshot({ path: path.join(screenshotDir, item.file), fullPage: true });
  }

  await page.goto(`${frontendUrl}/admin/supervision`, { waitUntil: "domcontentloaded" });
  await sleep(1800);
  const actionButtons = page.locator(".table-operations .ant-btn");
  if ((await actionButtons.count()) >= 2) {
    await actionButtons.nth(0).click();
    await sleep(1200);
    await actionButtons.nth(1).click();
    await sleep(1800);
  }
  await page.screenshot({
    path: path.join(screenshotDir, "07-admin-supervision-success.png"),
    fullPage: true,
  });

  const reportFiles = fs
    .readdirSync(reportDir)
    .filter((n) => /^acceptance-report-.*\.md$/i.test(n))
    .map((n) => ({
      name: n,
      full: path.join(reportDir, n),
      mtime: fs.statSync(path.join(reportDir, n)).mtimeMs,
    }))
    .sort((a, b) => b.mtime - a.mtime);
  const latest = reportFiles.length > 0 ? reportFiles[0] : null;
  const reportText = latest ? fs.readFileSync(latest.full, "utf8") : "No acceptance report found.";
  const html = `
    <html>
      <head><meta charset="utf-8"><title>Acceptance Report</title></head>
      <body style="font-family: Consolas, 'Courier New', monospace; margin: 24px; background: #f6f8fa;">
        <h2>Latest Acceptance Report: ${latest ? latest.name : "N/A"}</h2>
        <pre style="white-space: pre-wrap; background: white; padding: 16px; border: 1px solid #ddd;">${reportText
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")}</pre>
      </body>
    </html>
  `;
  await page.setContent(html, { waitUntil: "domcontentloaded" });
  await sleep(600);
  await page.screenshot({
    path: path.join(screenshotDir, "08-acceptance-report-pass.png"),
    fullPage: true,
  });
});
