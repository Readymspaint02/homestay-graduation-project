package com.ruoyi.biz.controller.homestay;

import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpRequest;
import cn.hutool.http.HttpResponse;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.service.ISysConfigService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;

import lombok.extern.slf4j.Slf4j;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

/**
 * AI assistant APIs (no vector DB version).
 */
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/ai")
public class HsAiController {

    private static final ExecutorService AI_EXECUTOR = Executors.newCachedThreadPool();

    private static final DecimalFormat MONEY_FORMAT = new DecimalFormat("0.00");
    private static final String DEFAULT_SYSTEM_PROMPT =
        "你是民宿预订顾问。请严格基于提供的数据回答，不得编造不存在的字段。输出要简洁，优先给结论、理由、风险提示。";

    private static final List<String> REVIEW_KEYWORDS = List.of(
        "干净", "卫生", "安静", "噪音", "交通", "地铁", "方便", "热情", "服务", "停车", "景色", "性价比", "医院", "亲子"
    );

    private final JdbcTemplate jdbcTemplate;
    private final ISysConfigService configService;

    private String getApiKey() {
        String key = configService.selectConfigByKey("ai.apiKey");
        return StrUtil.isNotBlank(key) ? key : apiKey;
    }

    private String getBaseUrl() {
        String url = configService.selectConfigByKey("ai.baseUrl");
        return StrUtil.isNotBlank(url) ? url : baseUrl;
    }

    private String getModel() {
        String m = configService.selectConfigByKey("ai.model");
        return StrUtil.isNotBlank(m) ? m : model;
    }

    @Value("${openai.api-key:}")
    private String apiKey;

    @Value("${openai.base-url:https://api.openai.com/v1}")
    private String baseUrl;

    @Value("${openai.model:gpt-4o-mini}")
    private String model;

    @Anonymous
    @PostMapping("/house/interpret")
    public AjaxResult interpret(@RequestBody AiInterpretRequest request) {
        if (request == null || request.getThingId() == null || request.getThingId() <= 0) {
            return AjaxResult.error("thingId不能为空");
        }
        HouseDigest house = loadHouseDigests(List.of(request.getThingId())).stream().findFirst().orElse(null);
        if (house == null) {
            return AjaxResult.error("房源不存在或已下架");
        }
        String question = StrUtil.blankToDefault(request.getQuestion(), "这套房适合什么人群？有哪些优缺点？");
        String answer = askWithFallback(buildInterpretPrompt(house, question), () -> fallbackInterpret(house, question), question);
        return AjaxResult.success(Map.of("answer", answer, "thingId", request.getThingId()));
    }

    @Anonymous
    @PostMapping("/house/compare")
    public AjaxResult compare(@RequestBody AiCompareRequest request) {
        List<Long> thingIds = normalizeThingIds(request == null ? null : request.getThingIds());
        if (thingIds.size() < 2) {
            return AjaxResult.error("至少提供2个房源ID用于对比");
        }
        List<HouseDigest> houses = loadHouseDigests(thingIds);
        if (houses.size() < 2) {
            return AjaxResult.error("可对比的房源不足");
        }
        String question = StrUtil.blankToDefault(request.getQuestion(), "请对比这些房源的性价比并给出建议。");
        String answer = askWithFallback(buildComparePrompt(houses, question), () -> fallbackCompare(houses, question), question);
        return AjaxResult.success(Map.of("answer", answer, "thingIds", thingIds));
    }

    @Anonymous
    @PostMapping(value = "/chat/stream", produces = "text/event-stream;charset=UTF-8")
    public SseEmitter chatStream(@RequestBody AiChatRequest request) {
        SseEmitter emitter = new SseEmitter(120000L);
        CompletableFuture.runAsync(() -> {
            String traceId = UUID.randomUUID().toString().replace("-", "");
            try {
                sendEvent(emitter, "start", traceId);
                String answer = handleChatRequest(request);
                streamByChunk(emitter, answer, 28);
                sendEvent(emitter, "done", "DONE");
                emitter.complete();
            } catch (Exception e) {
                try {
                    sendEvent(emitter, "error", StrUtil.blankToDefault(e.getMessage(), "AI服务处理失败"));
                } catch (IOException ignored) {
                }
                emitter.completeWithError(e);
            }
        }, AI_EXECUTOR);
        return emitter;
    }

    @PostMapping("/chat")
    public AjaxResult chat(@RequestBody AiChatRequest request) {
        String answer = handleChatRequest(request);
        return AjaxResult.success(Map.of("reply", answer));
    }

    private String handleChatRequest(AiChatRequest request) {
        String scene = request == null ? "" : StrUtil.blankToDefault(request.getScene(), "chat");
        String question = request == null ? "" : StrUtil.blankToDefault(request.getQuestion(), "");
        List<Long> thingIds = normalizeThingIds(request == null ? null : request.getThingIds());

        if ("admin".equalsIgnoreCase(scene)) {
            return handleAdminQuestion(question);
        }

        if ("landlord".equalsIgnoreCase(scene)) {
            return handleLandlordQuestion(question);
        }

        if ("interpret".equalsIgnoreCase(scene) && !thingIds.isEmpty()) {
            HouseDigest house = loadHouseDigests(List.of(thingIds.get(0))).stream().findFirst().orElse(null);
            if (house == null) return "未找到要解读的房源，请刷新列表后重试。";
            String q = StrUtil.blankToDefault(question, "请解读这套房源的适配人群与风险点。");
            return askWithFallback(buildInterpretPrompt(house, q), () -> fallbackInterpret(house, q), q);
        }

        if ("compare".equalsIgnoreCase(scene) && thingIds.size() >= 2) {
            List<HouseDigest> houses = loadHouseDigests(thingIds);
            if (houses.size() < 2) return "可对比房源不足，请至少选择两套房源。";
            String q = StrUtil.blankToDefault(question, "请从性价比和出行便利性对比这些房源。");
            return askWithFallback(buildComparePrompt(houses, q), () -> fallbackCompare(houses, q), q);
        }

        List<HouseDigest> houses = loadHouseDigests(thingIds);
        String safeQuestion = StrUtil.blankToDefault(question, "请根据现有房源给出推荐建议。");
        String prompt = buildGeneralPrompt(houses, safeQuestion, request == null ? null : request.getUserProfile());
        return askWithFallback(prompt, () -> fallbackGeneral(houses, safeQuestion), safeQuestion);
    }

    private String handleAdminQuestion(String question) {
        String prompt = buildAdminPrompt(question);
        String answer = callLlm(prompt);
        if (StrUtil.isNotBlank(answer)) {
            return answer;
        }
        return fallbackAdminAnswer(question);
    }

    private String handleLandlordQuestion(String question) {
        Map<String, Object> stats = getLandlordStats();
        String prompt = buildLandlordPrompt(question, stats);
        String answer = callLlmWithTimeout(prompt, 1500);
        if (StrUtil.isNotBlank(answer)) {
            return answer;
        }
        return fallbackLandlordAnswer(question, stats);
    }

    private String buildLandlordPrompt(String question, Map<String, Object> stats) {
        StringBuilder sb = new StringBuilder();
        sb.append("你是民宿短租管理平台的AI智能助手，专门为房东服务。\n");
        sb.append("你的职责是帮助房东分析订单、收入、房源等运营数据，提供经营建议。\n");
        sb.append("回答要简洁、专业、友好，直接回答问题，不要废话。\n\n");
        sb.append("当前房东运营数据：\n");
        sb.append("- 今日订单：").append(stats.get("todayOrders")).append("单\n");
        sb.append("- 今日收入：¥").append(stats.get("todayIncome")).append("\n");
        sb.append("- 待处理订单：").append(stats.get("pendingOrders")).append("单\n");
        sb.append("- 已确认订单：").append(stats.get("confirmedOrders")).append("单\n");
        sb.append("- 近7天订单：").append(stats.get("weekOrders")).append("单\n");
        sb.append("- 近7天收入：¥").append(stats.get("weekIncome")).append("\n");
        sb.append("- 房源总数：").append(stats.get("totalHomestays")).append("套\n");
        sb.append("- 已上架房源：").append(stats.get("activeHomestays")).append("套\n");
        sb.append("- 入住率：").append(stats.get("occupancyRate")).append("%\n");
        sb.append("\n房东问题：").append(question);
        return sb.toString();
    }

    private Map<String, Object> getLandlordStats() {
        Map<String, Object> stats = new LinkedHashMap<>();
        try {
            Long landlordUserId = com.ruoyi.common.utils.SecurityUtils.getUserId();
            
            stats.put("todayOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE landlord_user_id = ? AND DATE(create_time) = CURDATE()",
                Integer.class, landlordUserId));
            
            stats.put("todayIncome", jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(amount_payable), 0) FROM hs_order WHERE landlord_user_id = ? AND pay_status = '1' AND DATE(create_time) = CURDATE()",
                BigDecimal.class, landlordUserId));
            
            stats.put("pendingOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE landlord_user_id = ? AND order_status = '0'",
                Integer.class, landlordUserId));
            
            stats.put("confirmedOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE landlord_user_id = ? AND order_status = '1'",
                Integer.class, landlordUserId));
            
            stats.put("weekOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE landlord_user_id = ? AND create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)",
                Integer.class, landlordUserId));
            
            stats.put("weekIncome", jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(amount_payable), 0) FROM hs_order WHERE landlord_user_id = ? AND pay_status = '1' AND create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)",
                BigDecimal.class, landlordUserId));
            
            stats.put("totalHomestays", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_homestay WHERE landlord_user_id = ? AND del_flag = '0'",
                Integer.class, landlordUserId));
            
            stats.put("activeHomestays", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_homestay WHERE landlord_user_id = ? AND del_flag = '0' AND publish_status = '1'",
                Integer.class, landlordUserId));
            
            Integer total = (Integer) stats.get("totalHomestays");
            Integer active = (Integer) stats.get("activeHomestays");
            int occupancyRate = total > 0 ? (active * 100 / total) : 0;
            stats.put("occupancyRate", occupancyRate);
            
        } catch (Exception e) {
            log.error("获取房东统计数据失败", e);
            stats.put("todayOrders", 0);
            stats.put("todayIncome", BigDecimal.ZERO);
            stats.put("pendingOrders", 0);
            stats.put("confirmedOrders", 0);
            stats.put("weekOrders", 0);
            stats.put("weekIncome", BigDecimal.ZERO);
            stats.put("totalHomestays", 0);
            stats.put("activeHomestays", 0);
            stats.put("occupancyRate", 0);
        }
        return stats;
    }

    private String fallbackLandlordAnswer(String question, Map<String, Object> stats) {
        String q = question.toLowerCase();
        
        if (q.contains("今日订单") || q.contains("今天订单") || q.contains("今日有多少订单")) {
            return String.format("今日订单数据：\n\n- 新增订单：%d单\n- 待处理：%d单\n- 已确认：%d单\n\n建议：及时处理待确认订单，超时24小时将自动确认。",
                stats.get("todayOrders"), stats.get("pendingOrders"), stats.get("confirmedOrders"));
        }
        if (q.contains("今日收入") || q.contains("今天收入")) {
            return String.format("今日收入：¥%s\n\n建议：关注订单完成率，提升租客满意度可增加复购。",
                stats.get("todayIncome"));
        }
        if (q.contains("收入趋势") || q.contains("7天收入") || q.contains("近7天") || q.contains("周收入")) {
            return String.format("近7天收入数据：\n\n- 订单总数：%d单\n- 收入总额：¥%s\n\n建议：分析订单来源，优化房源定价策略。",
                stats.get("weekOrders"), stats.get("weekIncome"));
        }
        if (q.contains("入住率")) {
            return String.format("当前入住率：%d%%\n\n- 房源总数：%d套\n- 已上架：%d套\n\n建议：关注空置房源，可考虑调整价格或优化房源描述。",
                stats.get("occupancyRate"), stats.get("totalHomestays"), stats.get("activeHomestays"));
        }
        if (q.contains("待处理") || q.contains("待确认")) {
            return String.format("待处理订单：%d单\n\n请在「订单管理」页面及时处理，可接受或拒绝订单。拒绝需填写原因。",
                stats.get("pendingOrders"));
        }
        if (q.contains("房源")) {
            return String.format("房源概况：\n\n- 房源总数：%d套\n- 已上架：%d套\n\n可在「房源管理」页面发布新房源或编辑现有房源。",
                stats.get("totalHomestays"), stats.get("activeHomestays"));
        }
        if (q.contains("建议") || q.contains("经营") || q.contains("运营")) {
            return "房东运营建议：\n\n1. 及时处理待确认订单，提升响应速度\n2. 关注房态日历，避免重复预订\n3. 保持房源清洁，提升租客评价\n4. 分析收入趋势，优化定价策略\n5. 关注热门房源特征，复制成功经验";
        }
        
        String faqAnswer = searchLandlordFaq(question);
        if (StrUtil.isNotBlank(faqAnswer)) {
            return faqAnswer;
        }
        
        return "抱歉，我暂时无法回答这个问题。\n\n您可以尝试询问：\n- 今日订单数\n- 今日收入\n- 近7天收入趋势\n- 入住率\n- 待处理订单\n- 经营建议";
    }

    private String searchLandlordFaq(String question) {
        if (StrUtil.isBlank(question)) return "";
        String q = question.toLowerCase();
        
        if (q.contains("订单") && (q.contains("处理") || q.contains("确认"))) {
            return "订单处理：\n\n1. 在「订单管理」页面查看待处理订单\n2. 点击「接受」或「拒绝」按钮\n3. 拒绝订单需填写原因\n4. 超时24小时未处理将自动确认";
        }
        if (q.contains("房态") || q.contains("日历")) {
            return "房态日历管理：\n\n1. 在「房态日历」页面查看每日房态\n2. 已预订日期会灰掉，防止重复下单\n3. 可手动锁定/解锁日期\n4. 清洁中的日期也会标记";
        }
        if (q.contains("清洁")) {
            return "清洁管理：\n\n1. 在「清洁管理」页面查看清洁任务\n2. 点击「叫清洁」通知清洁人员\n3. 清洁完成后拍照上传\n4. 房源恢复可租状态";
        }
        if (q.contains("发布") || q.contains("上架")) {
            return "房源发布：\n\n1. 在「房源管理」页面点击「发布房源」\n2. 填写房源信息（标题、价格、地址等）\n3. 上传房源图片\n4. 提交后等待平台审核\n5. 审核通过后自动上架";
        }
        return "";
    }

    private String callLlmWithTimeout(String prompt, int timeoutMs) {
        String currentApiKey = getApiKey();
        String currentBaseUrl = getBaseUrl();
        String currentModel = getModel();
        
        if (StrUtil.isBlank(currentApiKey)) {
            log.warn("API key is blank, cannot call LLM");
            return "";
        }
        String endpoint = StrUtil.removeSuffix(currentBaseUrl, "/") + "/chat/completions";
        log.info("Calling LLM with timeout {}ms: endpoint={}, model={}", timeoutMs, endpoint, currentModel);

        JSONObject payload = new JSONObject();
        payload.put("model", currentModel);
        payload.put("temperature", 0.3);
        JSONArray messages = new JSONArray();
        messages.add(Map.of("role", "system", "content", DEFAULT_SYSTEM_PROMPT));
        messages.add(Map.of("role", "user", "content", prompt));
        payload.put("messages", messages);

        try (HttpResponse response = HttpRequest.post(endpoint)
            .header("Authorization", "Bearer " + currentApiKey)
            .header("Content-Type", "application/json")
            .timeout(timeoutMs)
            .body(payload.toJSONString())
            .execute()) {

            log.info("LLM response status: {}", response.getStatus());
            if (response.getStatus() < 200 || response.getStatus() >= 300) {
                log.error("LLM call failed: status={}, body={}", response.getStatus(), response.body());
                return "";
            }
            JSONObject json = JSON.parseObject(response.body());
            JSONArray choices = json.getJSONArray("choices");
            if (choices == null || choices.isEmpty()) {
                log.error("LLM response has no choices: {}", response.body());
                return "";
            }
            JSONObject messageObj = choices.getJSONObject(0).getJSONObject("message");
            String content = messageObj == null ? "" : messageObj.getString("content");
            log.info("LLM response content length: {}", content == null ? 0 : content.length());
            return content;
        } catch (Exception e) {
            log.error("LLM call exception (timeout {}ms): {}", timeoutMs, e.getMessage());
            return "";
        }
    }

    private String buildAdminPrompt(String question) {
        Map<String, Object> stats = getAdminStats();
        StringBuilder sb = new StringBuilder();
        sb.append("你是民宿短租管理平台的AI智能助手，由DeepSeek提供技术支持。\n");
        sb.append("你的职责是帮助平台管理员分析运营数据、提供经营建议。\n");
        sb.append("回答要简洁、专业、友好。如果用户问你是谁，请介绍自己是民宿平台的AI助手。\n\n");
        sb.append("当前运营数据：\n");
        sb.append("- 今日订单：").append(stats.get("todayOrders")).append("单\n");
        sb.append("- 今日房源：").append(stats.get("todayHomestays")).append("套\n");
        sb.append("- 今日用户：").append(stats.get("todayUsers")).append("人\n");
        sb.append("- 待支付订单：").append(stats.get("pendingOrders")).append("单\n");
        sb.append("- 已支付订单：").append(stats.get("paidOrders")).append("单\n");
        sb.append("- 近7天订单：").append(stats.get("weekOrders")).append("单\n");
        sb.append("- 近7天营收：¥").append(stats.get("weekRevenue")).append("\n");
        sb.append("\n管理员问题：").append(question);
        return sb.toString();
    }

    private Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new LinkedHashMap<>();
        try {
            stats.put("todayOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE DATE(create_time) = CURDATE()", Integer.class));
            stats.put("todayHomestays", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_homestay WHERE DATE(create_time) = CURDATE() AND del_flag = '0'", Integer.class));
            stats.put("todayUsers", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM sys_user WHERE DATE(create_time) = CURDATE() AND del_flag = '0'", Integer.class));
            stats.put("pendingOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE order_status = '0'", Integer.class));
            stats.put("paidOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE pay_status = '1'", Integer.class));
            stats.put("weekOrders", jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM hs_order WHERE create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)", Integer.class));
            stats.put("weekRevenue", jdbcTemplate.queryForObject(
                "SELECT COALESCE(SUM(amount_payable), 0) FROM hs_order WHERE pay_status = '1' AND create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)", BigDecimal.class));
        } catch (Exception e) {
            log.error("获取统计数据失败", e);
        }
        return stats;
    }

    private String fallbackAdminAnswer(String question) {
        String q = question.toLowerCase();
        Map<String, Object> stats = getAdminStats();
        
        if (q.contains("订单") || q.contains("今日")) {
            return String.format("今日运营数据：\n\n- 新增订单：%d单\n- 待支付：%d单\n- 已支付：%d单\n\n建议：及时关注待支付订单，超时30分钟将自动关闭。",
                stats.get("todayOrders"), stats.get("pendingOrders"), stats.get("paidOrders"));
        }
        if (q.contains("收入") || q.contains("趋势") || q.contains("7天") || q.contains("近7天")) {
            return String.format("近7天运营数据：\n\n- 订单总数：%d单\n- 营收总额：¥%s\n\n建议：分析订单趋势，优化定价策略。",
                stats.get("weekOrders"), stats.get("weekRevenue"));
        }
        if (q.contains("入住率")) {
            return "入住率数据可在运营看板页面查看。\n\n建议关注热门房源的入住情况，及时调整定价策略。";
        }
        if (q.contains("建议") || q.contains("经营")) {
            return "运营建议：\n\n1. 及时处理待审核房源\n2. 关注异常订单（金额>20k或退款率高）\n3. 分析热门房源特征\n4. 优化定价策略";
        }
        
        return "抱歉，我暂时无法回答这个问题。\n\n您可以：\n1. 点击生成日报获取今日运营摘要\n2. 点击生成周报获取近7天运营分析";
    }

    private String askWithFallback(String prompt, Fallback fallback, String question) {
        String answer = callLlm(prompt);
        if (StrUtil.isNotBlank(answer)) {
            return answer.trim();
        }
        String faqAnswer = searchFaq(question);
        if (StrUtil.isNotBlank(faqAnswer)) {
            return faqAnswer;
        }
        return fallback.run();
    }

    private String callLlm(String prompt) {
        String currentApiKey = getApiKey();
        String currentBaseUrl = getBaseUrl();
        String currentModel = getModel();
        
        if (StrUtil.isBlank(currentApiKey)) {
            log.warn("API key is blank, cannot call LLM");
            return "";
        }
        String endpoint = StrUtil.removeSuffix(currentBaseUrl, "/") + "/chat/completions";
        log.info("Calling LLM: endpoint={}, model={}", endpoint, currentModel);

        JSONObject payload = new JSONObject();
        payload.put("model", currentModel);
        payload.put("temperature", 0.3);
        JSONArray messages = new JSONArray();
        messages.add(Map.of("role", "system", "content", DEFAULT_SYSTEM_PROMPT));
        messages.add(Map.of("role", "user", "content", prompt));
        payload.put("messages", messages);

        try (HttpResponse response = HttpRequest.post(endpoint)
            .header("Authorization", "Bearer " + currentApiKey)
            .header("Content-Type", "application/json")
            .timeout(60000)
            .body(payload.toJSONString())
            .execute()) {

            log.info("LLM response status: {}", response.getStatus());
            if (response.getStatus() < 200 || response.getStatus() >= 300) {
                log.error("LLM call failed: status={}, body={}", response.getStatus(), response.body());
                return "";
            }
            JSONObject json = JSON.parseObject(response.body());
            JSONArray choices = json.getJSONArray("choices");
            if (choices == null || choices.isEmpty()) {
                log.error("LLM response has no choices: {}", response.body());
                return "";
            }
            JSONObject messageObj = choices.getJSONObject(0).getJSONObject("message");
            String content = messageObj == null ? "" : messageObj.getString("content");
            log.info("LLM response content length: {}", content == null ? 0 : content.length());
            return content;
        } catch (Exception e) {
            log.error("LLM call exception: {}", e.getMessage(), e);
            return "";
        }
    }

    private void streamByChunk(SseEmitter emitter, String text, int chunkSize) throws IOException, InterruptedException {
        String safe = StrUtil.blankToDefault(text, "AI暂无可返回内容，请稍后重试。");
        for (int i = 0; i < safe.length(); i += chunkSize) {
            int end = Math.min(i + chunkSize, safe.length());
            sendEvent(emitter, "delta", safe.substring(i, end));
            Thread.sleep(25L);
        }
    }

    private void sendEvent(SseEmitter emitter, String event, String data) throws IOException {
        emitter.send(SseEmitter.event().name(event).data(StrUtil.blankToDefault(data, "")));
    }

    private List<Long> normalizeThingIds(List<Long> rawIds) {
        if (CollectionUtils.isEmpty(rawIds)) {
            return Collections.emptyList();
        }
        return rawIds.stream()
            .filter(Objects::nonNull)
            .filter(id -> id > 0)
            .distinct()
            .limit(8)
            .collect(Collectors.toList());
    }

    private List<HouseDigest> loadHouseDigests(List<Long> thingIds) {
        if (CollectionUtils.isEmpty(thingIds)) {
            return Collections.emptyList();
        }

        String placeholders = thingIds.stream().map(id -> "?").collect(Collectors.joining(","));
        String sql = "SELECT id, title, city, address, base_price, rating_avg, rating_count, max_guests, description " +
            "FROM hs_homestay WHERE del_flag = '0' AND id IN (" + placeholders + ")";
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, thingIds.toArray());
        if (rows.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Long, HouseDigest> digestMap = new LinkedHashMap<>();
        for (Map<String, Object> row : rows) {
            HouseDigest digest = new HouseDigest();
            digest.setId(toLong(row.get("id")));
            digest.setTitle(StrUtil.blankToDefault(Objects.toString(row.get("title"), ""), "未命名房源"));
            digest.setCity(StrUtil.blankToDefault(Objects.toString(row.get("city"), ""), "-"));
            digest.setAddress(StrUtil.blankToDefault(Objects.toString(row.get("address"), ""), "-"));
            digest.setBasePrice(toDecimal(row.get("base_price")));
            digest.setRatingAvg(toDecimal(row.get("rating_avg")));
            digest.setRatingCount(toInt(row.get("rating_count")));
            digest.setMaxGuests(toInt(row.get("max_guests")));
            digest.setDescription(StrUtil.blankToDefault(Objects.toString(row.get("description"), ""), ""));
            digestMap.put(digest.getId(), digest);
        }

        fillReviewInfo(digestMap);
        return thingIds.stream().map(digestMap::get).filter(Objects::nonNull).collect(Collectors.toList());
    }

    private void fillReviewInfo(Map<Long, HouseDigest> digestMap) {
        if (digestMap.isEmpty()) return;
        String placeholders = digestMap.keySet().stream().map(id -> "?").collect(Collectors.joining(","));
        String sql = "SELECT homestay_id, rating, content FROM hs_review WHERE homestay_id IN (" + placeholders + ") " +
            "ORDER BY create_time DESC LIMIT 300";
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, digestMap.keySet().toArray());

        Map<Long, List<String>> reviewMap = new LinkedHashMap<>();
        for (Map<String, Object> row : rows) {
            Long homestayId = toLong(row.get("homestay_id"));
            if (homestayId == null || !digestMap.containsKey(homestayId)) continue;
            String content = Objects.toString(row.get("content"), "").trim();
            if (content.isEmpty()) continue;
            reviewMap.computeIfAbsent(homestayId, k -> new ArrayList<>()).add(content);
        }

        for (Map.Entry<Long, HouseDigest> entry : digestMap.entrySet()) {
            List<String> reviews = reviewMap.getOrDefault(entry.getKey(), Collections.emptyList());
            HouseDigest digest = entry.getValue();
            digest.setReviewSamples(reviews.stream().limit(3).collect(Collectors.toList()));
            digest.setReviewKeywords(extractKeywords(reviews));
        }
    }

    private String extractKeywords(List<String> reviews) {
        if (CollectionUtils.isEmpty(reviews)) return "暂无";
        Map<String, Integer> counter = new LinkedHashMap<>();
        for (String keyword : REVIEW_KEYWORDS) {
            int count = 0;
            for (String review : reviews) {
                if (review.contains(keyword)) {
                    count++;
                }
            }
            if (count > 0) {
                counter.put(keyword, count);
            }
        }
        if (counter.isEmpty()) return "暂无";
        return counter.entrySet().stream()
            .sorted((a, b) -> Integer.compare(b.getValue(), a.getValue()))
            .limit(5)
            .map(entry -> entry.getKey())
            .collect(Collectors.joining("、"));
    }

    private String buildInterpretPrompt(HouseDigest house, String question) {
        StringBuilder sb = new StringBuilder();
        sb.append("请解读以下房源，并回答用户问题。\n");
        sb.append("输出格式：\n");
        sb.append("1) 结论（1句话）\n");
        sb.append("2) 适配人群（2-3条）\n");
        sb.append("3) 风险提示（至少1条）\n");
        sb.append("4) 建议（1条）\n\n");
        sb.append("房源数据：\n");
        sb.append(toHouseLine(house)).append("\n");
        sb.append("用户问题：").append(question);
        return sb.toString();
    }

    private String buildComparePrompt(List<HouseDigest> houses, String question) {
        StringBuilder sb = new StringBuilder();
        sb.append("请对比以下房源并回答用户问题。\n");
        sb.append("要求：\n");
        sb.append("1) 先给Markdown对比表（至少包含价格、评分、可住人数、关键词）\n");
        sb.append("2) 给出每套房源优缺点\n");
        sb.append("3) 最后给出明确推荐结论\n\n");
        for (HouseDigest house : houses) {
            sb.append(toHouseLine(house)).append("\n");
        }
        sb.append("用户问题：").append(question);
        return sb.toString();
    }

    private String buildGeneralPrompt(List<HouseDigest> houses, String question, Map<String, Object> userProfile) {
        StringBuilder sb = new StringBuilder();
        sb.append("请作为民宿顾问回答问题，基于给定房源数据。\n");
        if (!CollectionUtils.isEmpty(userProfile)) {
            sb.append("用户画像：").append(JSON.toJSONString(userProfile)).append("\n");
        }
        if (!CollectionUtils.isEmpty(houses)) {
            sb.append("可用房源：\n");
            for (HouseDigest house : houses) {
                sb.append(toHouseLine(house)).append("\n");
            }
        } else {
            sb.append("可用房源：暂无结构化数据。\n");
        }
        sb.append("问题：").append(question);
        return sb.toString();
    }

    private String toHouseLine(HouseDigest house) {
        return String.format(
            Locale.ROOT,
            "【房源%d】%s；城市:%s；地址:%s；价格:¥%s/晚；评分:%s(%d条)；可住:%d人；评价关键词:%s；描述:%s",
            house.getId(),
            house.getTitle(),
            house.getCity(),
            house.getAddress(),
            MONEY_FORMAT.format(house.getBasePrice()),
            MONEY_FORMAT.format(house.getRatingAvg()),
            house.getRatingCount(),
            house.getMaxGuests(),
            house.getReviewKeywords(),
            StrUtil.blankToDefault(house.getDescription(), "-")
        );
    }

    private String fallbackInterpret(HouseDigest house, String question) {
        List<String> risks = new ArrayList<>();
        if (house.getRatingCount() < 5) risks.add("评价样本较少，建议联系房东确认细节");
        if (house.getRatingAvg().compareTo(new BigDecimal("4.2")) < 0) risks.add("评分偏低，需重点查看差评原因");
        if (StrUtil.isBlank(house.getDescription()) || house.getDescription().length() < 16) risks.add("房源描述较少，信息透明度一般");
        if (risks.isEmpty()) risks.add("暂无明显风险，仍建议确认退改与入住时间");

        StringBuilder sb = new StringBuilder();
        sb.append("结论：").append(house.getTitle()).append("整体可考虑，适合重视基础入住体验的用户。\n");
        sb.append("关键信息：价格¥").append(MONEY_FORMAT.format(house.getBasePrice())).append("/晚，评分")
            .append(MONEY_FORMAT.format(house.getRatingAvg())).append("（").append(house.getRatingCount()).append("条），可住")
            .append(house.getMaxGuests()).append("人。\n");
        sb.append("评价关键词：").append(house.getReviewKeywords()).append("。\n");
        sb.append("风险提示：").append(String.join("；", risks)).append("。\n");
        sb.append("建议：如果你这次关注“").append(question).append("”，建议先与房东确认停车/交通和入住细节后再下单。");
        return sb.toString();
    }

    private String fallbackCompare(List<HouseDigest> houses, String question) {
        List<HouseDigest> sorted = new ArrayList<>(houses);
        sorted.sort(Comparator.comparing(HouseDigest::getBasePrice));
        HouseDigest cheapest = sorted.get(0);
        HouseDigest bestRating = houses.stream()
            .max(Comparator.comparing(HouseDigest::getRatingAvg))
            .orElse(cheapest);

        StringBuilder table = new StringBuilder();
        table.append("| 房源 | 价格/晚 | 评分 | 可住人数 | 关键词 |\n");
        table.append("|---|---:|---:|---:|---|\n");
        for (HouseDigest house : houses) {
            table.append("| ").append(house.getTitle())
                .append(" | ¥").append(MONEY_FORMAT.format(house.getBasePrice()))
                .append(" | ").append(MONEY_FORMAT.format(house.getRatingAvg()))
                .append(" | ").append(house.getMaxGuests())
                .append(" | ").append(house.getReviewKeywords())
                .append(" |\n");
        }

        return table + "\n" +
            "对比结论：\n" +
            "- 性价比优先：**" + cheapest.getTitle() + "**（价格最低）。\n" +
            "- 稳定体验优先：**" + bestRating.getTitle() + "**（评分最高）。\n" +
            "- 风险建议：优先排除评价数过少且评分偏低的房源。\n" +
            "结合你的问题「" + question + "」，建议先选 " + bestRating.getTitle() + "，预算紧张时再选 " + cheapest.getTitle() + "。";
    }

    private String fallbackGeneral(List<HouseDigest> houses, String question) {
        String faqAnswer = searchFaq(question);
        if (StrUtil.isNotBlank(faqAnswer)) {
            return faqAnswer;
        }
        if (houses.isEmpty()) {
            return "当前没有可用房源上下文。您可以尝试询问：如何预订、如何支付、如何取消订单等常见问题。";
        }
        HouseDigest target = houses.stream()
            .sorted(Comparator.comparing(HouseDigest::getRatingAvg).reversed())
            .findFirst()
            .orElse(houses.get(0));
        return "根据当前数据，优先推荐「" + target.getTitle() + "」。" +
            "它评分较高（" + MONEY_FORMAT.format(target.getRatingAvg()) + "）且评价关键词为「" + target.getReviewKeywords() + "」。" +
            "如果你关注「" + question + "」，建议再对比同价位房源的交通与退改政策。";
    }

    private Long toLong(Object val) {
        if (val == null) return null;
        if (val instanceof Number n) return n.longValue();
        try {
            return Long.parseLong(String.valueOf(val));
        } catch (Exception e) {
            return null;
        }
    }

    private Integer toInt(Object val) {
        if (val == null) return 0;
        if (val instanceof Number n) return n.intValue();
        try {
            return Integer.parseInt(String.valueOf(val));
        } catch (Exception e) {
            return 0;
        }
    }

    private BigDecimal toDecimal(Object val) {
        if (val == null) return BigDecimal.ZERO;
        if (val instanceof BigDecimal bd) return bd;
        try {
            return new BigDecimal(String.valueOf(val));
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    @FunctionalInterface
    private interface Fallback {
        String run();
    }

    private String searchFaq(String question) {
        if (StrUtil.isBlank(question)) return "";
        try {
            String sql = "SELECT question, answer, keywords FROM hs_faq WHERE status = '1' ORDER BY sort_order ASC, id ASC";
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql);
            if (rows.isEmpty()) return "";

            String q = question.toLowerCase();
            List<String> matches = new ArrayList<>();
            for (Map<String, Object> row : rows) {
                String keywords = Objects.toString(row.get("keywords"), "").toLowerCase();
                String[] kwArr = keywords.split(",");
                for (String kw : kwArr) {
                    if (q.contains(kw.trim().toLowerCase())) {
                        matches.add("问：" + row.get("question") + "\n答：" + row.get("answer"));
                        break;
                    }
                }
            }
            if (matches.isEmpty()) return "";
            return "根据常见问题库为您解答：\n\n" + String.join("\n\n---\n\n", matches);
        } catch (Exception e) {
            log.error("FAQ search failed", e);
            return "";
        }
    }

    @Data
    public static class AiInterpretRequest {
        private Long thingId;
        private String question;
    }

    @Data
    public static class AiCompareRequest {
        private List<Long> thingIds;
        private String question;
    }

    @Data
    public static class AiChatRequest {
        private String scene;
        private String question;
        private List<Long> thingIds;
        private String sessionId;
        private Map<String, Object> userProfile;
    }

    @Data
    private static class HouseDigest {
        private Long id;
        private String title;
        private String city;
        private String address;
        private BigDecimal basePrice = BigDecimal.ZERO;
        private BigDecimal ratingAvg = BigDecimal.ZERO;
        private Integer ratingCount = 0;
        private Integer maxGuests = 1;
        private String description;
        private String reviewKeywords = "暂无";
        private List<String> reviewSamples = Collections.emptyList();
    }

    @PostMapping("/report/daily")
    public AjaxResult generateDailyReport() {
        try {
            String report = generateReport("daily");
            return AjaxResult.success(Map.of("report", report));
        } catch (Exception e) {
            log.error("生成日报失败", e);
            String fallbackReport = generateFallbackDailyReport();
            return AjaxResult.success(Map.of("report", fallbackReport));
        }
    }

    @PostMapping("/report/weekly")
    public AjaxResult generateWeeklyReport() {
        try {
            String report = generateReport("weekly");
            return AjaxResult.success(Map.of("report", report));
        } catch (Exception e) {
            log.error("生成周报失败", e);
            String fallbackReport = generateFallbackWeeklyReport();
            return AjaxResult.success(Map.of("report", fallbackReport));
        }
    }

    private String generateReport(String type) {
        Map<String, Object> stats = getReportStats(type);
        String prompt = buildReportPrompt(type, stats);
        String answer = callLlm(prompt);
        if (StrUtil.isNotBlank(answer)) {
            return answer;
        }
        return type.equals("daily") ? generateFallbackDailyReport() : generateFallbackWeeklyReport();
    }

    private Map<String, Object> getReportStats(String type) {
        Map<String, Object> stats = new LinkedHashMap<>();
        try {
            if ("daily".equals(type)) {
                stats.put("todayOrders", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM hs_order WHERE DATE(create_time) = CURDATE()", Integer.class));
                stats.put("todayHomestays", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM hs_homestay WHERE DATE(create_time) = CURDATE() AND del_flag = '0'", Integer.class));
                stats.put("todayUsers", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM sys_user WHERE DATE(create_time) = CURDATE() AND del_flag = '0'", Integer.class));
                stats.put("pendingOrders", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM hs_order WHERE order_status = '0'", Integer.class));
                stats.put("paidOrders", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM hs_order WHERE order_status = '1'", Integer.class));
            } else {
                stats.put("weekOrders", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM hs_order WHERE create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)", Integer.class));
                stats.put("weekRevenue", jdbcTemplate.queryForObject(
                    "SELECT COALESCE(SUM(amount_payable), 0) FROM hs_order WHERE pay_status = '1' AND create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)", BigDecimal.class));
                stats.put("weekHomestays", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM hs_homestay WHERE create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND del_flag = '0'", Integer.class));
                stats.put("weekUsers", jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM sys_user WHERE create_time >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) AND del_flag = '0'", Integer.class));
            }
        } catch (Exception e) {
            log.error("获取统计数据失败", e);
        }
        return stats;
    }

    private String buildReportPrompt(String type, Map<String, Object> stats) {
        StringBuilder sb = new StringBuilder();
        if ("daily".equals(type)) {
            sb.append("请根据以下数据生成今日运营日报，使用自然语言描述，包含：\n");
            sb.append("1. 今日数据摘要（订单、房源、用户）\n");
            sb.append("2. 待处理事项提醒\n");
            sb.append("3. 运营建议（2-3条）\n\n");
            sb.append("今日数据：\n");
            sb.append("- 新增订单：").append(stats.getOrDefault("todayOrders", 0)).append("单\n");
            sb.append("- 新增房源：").append(stats.getOrDefault("todayHomestays", 0)).append("套\n");
            sb.append("- 新增用户：").append(stats.getOrDefault("todayUsers", 0)).append("人\n");
            sb.append("- 待支付订单：").append(stats.getOrDefault("pendingOrders", 0)).append("单\n");
            sb.append("- 已支付订单：").append(stats.getOrDefault("paidOrders", 0)).append("单\n");
        } else {
            sb.append("请根据以下数据生成近7天运营周报，使用自然语言描述，包含：\n");
            sb.append("1. 周数据摘要\n");
            sb.append("2. 趋势分析\n");
            sb.append("3. 运营建议（3-5条）\n\n");
            sb.append("近7天数据：\n");
            sb.append("- 订单总数：").append(stats.getOrDefault("weekOrders", 0)).append("单\n");
            sb.append("- 营收总额：¥").append(stats.getOrDefault("weekRevenue", 0)).append("\n");
            sb.append("- 新增房源：").append(stats.getOrDefault("weekHomestays", 0)).append("套\n");
            sb.append("- 新增用户：").append(stats.getOrDefault("weekUsers", 0)).append("人\n");
        }
        return sb.toString();
    }

    private String generateFallbackDailyReport() {
        return "【今日运营日报 - FAQ降级模式】\n\n" +
            "由于AI服务暂时不可用，以下是基础数据摘要：\n\n" +
            "建议操作：\n" +
            "1. 检查待审核房源，及时处理\n" +
            "2. 关注异常订单，进行人工复核\n" +
            "3. 确认已支付订单入住状态\n\n" +
            "（AI服务恢复后将提供更详细的智能分析）";
    }

    private String generateFallbackWeeklyReport() {
        return "【近7天运营周报 - FAQ降级模式】\n\n" +
            "由于AI服务暂时不可用，以下是基础分析：\n\n" +
            "关键指标建议：\n" +
            "1. 关注入住率变化趋势\n" +
            "2. 分析热门房源特征\n" +
            "3. 优化定价策略\n" +
            "4. 提升用户满意度\n\n" +
            "（AI服务恢复后将提供更详细的智能分析）";
    }

    @PostMapping("/config/test")
    public AjaxResult testAiConfig(@RequestBody AiConfigTestRequest request) {
        String testApiKey = request.getApiKey();
        String testBaseUrl = request.getBaseUrl();
        String testModel = request.getModel();
        
        if (StrUtil.isBlank(testApiKey)) {
            return AjaxResult.error("API Key不能为空");
        }
        if (StrUtil.isBlank(testBaseUrl)) {
            return AjaxResult.error("API地址不能为空");
        }
        if (StrUtil.isBlank(testModel)) {
            return AjaxResult.error("模型名称不能为空");
        }

        String endpoint = StrUtil.removeSuffix(testBaseUrl, "/") + "/chat/completions";
        
        JSONObject payload = new JSONObject();
        payload.put("model", testModel);
        payload.put("temperature", 0.3);
        payload.put("max_tokens", 50);
        JSONArray messages = new JSONArray();
        messages.add(Map.of("role", "user", "content", "你好，请回复'测试成功'"));
        payload.put("messages", messages);

        try (HttpResponse response = HttpRequest.post(endpoint)
            .header("Authorization", "Bearer " + testApiKey)
            .header("Content-Type", "application/json")
            .timeout(30000)
            .body(payload.toJSONString())
            .execute()) {

            if (response.getStatus() < 200 || response.getStatus() >= 300) {
                String errorMsg = "连接失败，状态码：" + response.getStatus();
                try {
                    JSONObject errorJson = JSON.parseObject(response.body());
                    if (errorJson.containsKey("error")) {
                        errorMsg = errorJson.getJSONObject("error").getString("message");
                    }
                } catch (Exception ignored) {}
                return AjaxResult.error("测试失败：" + errorMsg);
            }
            
            JSONObject json = JSON.parseObject(response.body());
            JSONArray choices = json.getJSONArray("choices");
            if (choices == null || choices.isEmpty()) {
                return AjaxResult.error("测试失败：响应格式异常");
            }
            
            JSONObject messageObj = choices.getJSONObject(0).getJSONObject("message");
            String content = messageObj == null ? "" : messageObj.getString("content");
            return AjaxResult.success("测试成功", Map.of("reply", content));
        } catch (Exception e) {
            log.error("AI config test failed", e);
            return AjaxResult.error("测试失败：" + e.getMessage());
        }
    }

    @PostMapping("/config/test/chat")
    public AjaxResult testAiChat(@RequestBody AiConfigTestRequest request) {
        String testApiKey = request.getApiKey();
        String testBaseUrl = request.getBaseUrl();
        String testModel = request.getModel();
        String message = request.getMessage();
        
        if (StrUtil.isBlank(testApiKey)) {
            testApiKey = getApiKey();
        }
        if (StrUtil.isBlank(testBaseUrl)) {
            testBaseUrl = getBaseUrl();
        }
        if (StrUtil.isBlank(testModel)) {
            testModel = getModel();
        }
        
        if (StrUtil.isBlank(testApiKey)) {
            return AjaxResult.error("API Key不能为空");
        }
        if (StrUtil.isBlank(testBaseUrl)) {
            return AjaxResult.error("API地址不能为空");
        }
        if (StrUtil.isBlank(testModel)) {
            return AjaxResult.error("模型名称不能为空");
        }
        if (StrUtil.isBlank(message)) {
            message = "你好";
        }

        String endpoint = StrUtil.removeSuffix(testBaseUrl, "/") + "/chat/completions";
        log.info("Testing AI chat: endpoint={}, model={}, message={}", endpoint, testModel, message);
        
        JSONObject payload = new JSONObject();
        payload.put("model", testModel);
        payload.put("temperature", 0.7);
        payload.put("max_tokens", 500);
        
        JSONArray messages = new JSONArray();
        messages.add(Map.of("role", "system", "content", "你是民宿短租管理平台的AI智能助手。你的职责是帮助用户解答关于民宿预订、房源管理、订单处理等问题。回答要简洁、专业、友好。"));
        messages.add(Map.of("role", "user", "content", message));
        payload.put("messages", messages);

        try (HttpResponse response = HttpRequest.post(endpoint)
            .header("Authorization", "Bearer " + testApiKey)
            .header("Content-Type", "application/json")
            .timeout(60000)
            .body(payload.toJSONString())
            .execute()) {

            log.info("AI chat response status: {}", response.getStatus());
            if (response.getStatus() < 200 || response.getStatus() >= 300) {
                String errorMsg = "连接失败，状态码：" + response.getStatus();
                try {
                    JSONObject errorJson = JSON.parseObject(response.body());
                    if (errorJson.containsKey("error")) {
                        errorMsg = errorJson.getJSONObject("error").getString("message");
                    }
                } catch (Exception ignored) {}
                return AjaxResult.error("对话失败：" + errorMsg);
            }
            
            JSONObject json = JSON.parseObject(response.body());
            JSONArray choices = json.getJSONArray("choices");
            if (choices == null || choices.isEmpty()) {
                return AjaxResult.error("对话失败：响应格式异常");
            }
            
            JSONObject messageObj = choices.getJSONObject(0).getJSONObject("message");
            String content = messageObj == null ? "" : messageObj.getString("content");
            log.info("AI chat response content: {}", content);
            return AjaxResult.success(Map.of("reply", StrUtil.blankToDefault(content, "AI返回为空")));
        } catch (Exception e) {
            log.error("AI chat test failed", e);
            return AjaxResult.error("对话失败：" + e.getMessage());
        }
    }

    @GetMapping("/config")
    public AjaxResult getAiConfig() {
        String provider = configService.selectConfigByKey("ai.provider");
        return AjaxResult.success(Map.of(
            "apiKey", StrUtil.isNotBlank(getApiKey()) ? "******" : "",
            "baseUrl", getBaseUrl(),
            "model", getModel(),
            "provider", StrUtil.isNotBlank(provider) ? provider : "deepseek"
        ));
    }

    @GetMapping("/config/yml")
    public AjaxResult getAiConfigFromYml() {
        String provider = configService.selectConfigByKey("ai.provider");
        if (StrUtil.isBlank(provider)) {
            provider = "deepseek";
        }
        return AjaxResult.success(Map.of(
            "apiKey", apiKey,
            "baseUrl", baseUrl,
            "model", model,
            "provider", provider
        ));
    }

    @Data
    public static class AiConfigTestRequest {
        private String apiKey;
        private String baseUrl;
        private String model;
        private String message;
    }
}
