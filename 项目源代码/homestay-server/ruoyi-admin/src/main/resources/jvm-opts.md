# ============================================
# JVM 调优配置说明 (面试知识点)
# ============================================
# 
# 【启动参数配置】(生产环境建议)
# ============================================
# 
# 1. 堆内存配置
# -Xms2g -Xmx2g              # 初始和最大堆内存设为相同，避免动态调整开销
# 
# 2. 垃圾回收器
# -XX:+UseG1GC               # 使用 G1 垃圾回收器 (JDK9+ 默认)
# -XX:MaxGCPauseMillis=200   # 最大 GC 停顿时间目标
# -XX:G1HeapRegionSize=4m    # G1 区域大小
# 
# 3. GC 日志配置
# -Xlog:gc*:file=logs/gc.log:time,uptime:filecount=5,filesize=10M
# 
# 4. OOM 排查配置
# -XX:+HeapDumpOnOutOfMemoryError
# -XX:HeapDumpPath=logs/heapdump.hprof
# 
# 5. 元空间配置
# -XX:MetaspaceSize=256m     # 元空间初始大小
# -XX:MaxMetaspaceSize=512m  # 元空间最大值
# 
# 6. JVM 优化选项
# -XX:+UseStringDeduplication  # 字符串去重 (G1 专属)
# -XX:+ParallelRefProcEnabled  # 并行引用处理
# -XX:+UnlockDiagnosticVMOptions # 解锁诊断选项
# 
# ============================================
# 【完整启动命令示例】
# ============================================
# java -Xms2g -Xmx2g \
#      -XX:+UseG1GC \
#      -XX:MaxGCPauseMillis=200 \
#      -XX:+HeapDumpOnOutOfMemoryError \
#      -XX:HeapDumpPath=logs/heapdump.hprof \
#      -Xlog:gc*:file=logs/gc.log:time,uptime:filecount=5,filesize=10M \
#      -XX:+UseStringDeduplication \
#      -XX:MetaspaceSize=256m \
#      -XX:MaxMetaspaceSize=512m \
#      -jar ruoyi-admin.jar
# 
# ============================================
# 【面试话术 - JVM 调优】
# ============================================
# 
# 面试官：你们生产环境是怎么配置 JVM 参数的？
# 
# 我：我们根据应用类型和服务器配置来调整 JVM 参数：
# 
# 1. **堆内存配置**
#    - 初始和最大堆内存设为相同 (如 2G)，避免动态调整开销
#    - 对于我们的民宿项目，2G 堆内存足够支撑日常流量
# 
# 2. **垃圾回收器选择**
#    - 使用 G1 GC，适合大内存、低延迟场景
#    - MaxGCPauseMillis 设为 200ms，平衡吞吐量和延迟
# 
# 3. **GC 日志**
#    - 配置了 GC 日志滚动保存 (5 个文件，每个 10M)
#    - 用于问题排查和性能分析
# 
# 4. **OOM 排查**
#    - 配置了 OOM 时自动 dump 堆内存
#    - 结合 MAT 工具分析内存泄漏
# 
# 5. **实际调优案例**
#    - 有一次发现 Full GC 频繁，通过 MAT 分析发现是某个缓存未设置过期时间
#    - 修复后 Full GC 从每小时 1 次降到每天 1 次
# 
# ============================================
# 【常用 JVM 调优工具】
# ============================================
# 1. jps - 查看 Java 进程
# 2. jstat -gc <pid> 1000 - 实时监控 GC 状态
# 3. jmap -dump:format=b,file=heap.hprof <pid> - 手动 dump 堆内存
# 4. jstack <pid> - 线程栈分析 (死锁排查)
# 5. VisualVM - 图形化监控工具
# 6. MAT - 堆内存分析工具
# 7. GCEasy - 在线 GC 日志分析工具 (https://gceasy.io)
# 
# ============================================
