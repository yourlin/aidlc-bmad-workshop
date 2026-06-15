# Sprint Plan: Hotel Booking Inventory API

> 预填版本 — Workshop 应急使用

## Sprint 目标

在 70 分钟内交付至少 2 个可工作的 API 端点，包含完整的测试覆盖。

## Story 列表

| # | Story | 负责人 | 优先级 | 预估 | 依赖 |
|---|-------|--------|--------|------|------|
| 1 | 创建房间 (POST /rooms) | 开发 | P0 | 25min | 无 |
| 2 | 获取房间 (GET /rooms/{id}) | 开发 | P0 | 15min | Story 1 |
| 3 | 列出房间 (GET /rooms) | 开发 | P1 | 15min | Story 1 |
| 4 | 查询可用性 (GET /availability) | 开发 | P1 | 15min | Story 1 |
| 5 | CDK Stack (DynamoDB + Lambda + APIGW) | 架构师 | P0 | 30min | 无 |
| 6 | 单元测试 (handlers) | QA | P0 | 25min | Story 1 |
| 7 | E2E 测试 | 测试工程师 | P1 | 25min | Story 1, 5 |
| 8 | 性能测试脚本 | 测试工程师 | P2 | 15min | Story 7 |

## 并行执行计划

```
时间线 (70 min)
─────────────────────────────────────────────────────────────────────────
开发:     [Story 1: 25min] → [Story 2: 15min] → [Story 3: 15min] → [Story 4: 15min]
架构师:   [CDK Stack: 30min] ────────→ [调试 + 完善: 20min] → [支援开发]
QA:       [验收用例: 15min] → [单元测试: 25min] ────────→ [覆盖率检查]
测试工程师: [E2E框架: 10min] → [E2E测试: 25min] ──→ [性能测试: 15min]
─────────────────────────────────────────────────────────────────────────
                      ↑ 35min 中期检查点
```

## 每个 Story 的 Definition of Done

### Story 1: 创建房间
- [ ] POST /api/v1/rooms 返回 201
- [ ] Zod 验证：缺少必填字段返回 400
- [ ] 数据写入 DynamoDB
- [ ] 单元测试通过

### Story 2: 获取房间
- [ ] GET /api/v1/rooms/{id} 返回 200 + 房间数据
- [ ] 不存在的 ID 返回 404
- [ ] 已归档（软删除）的房间返回 410 Gone + archivedAt
- [ ] 单元测试通过

### Story 3: 列出房间
- [ ] GET /api/v1/rooms 返回房间列表（支持 status/type 筛选）
- [ ] 支持分页 (limit + lastKey)
- [ ] 空结果返回 200 + 空数组

### Story 4: 查询可用性
- [ ] GET /api/v1/rooms/availability?start=X&end=Y（按日期范围）
- [ ] 返回日期范围内的可用性数据
- [ ] 日期格式错误返回 400

## 中期检查点 (35 分钟)

到 35 分钟时必须达成：
- ✅ Story 1 完成
- ✅ QA 验收用例已定义
- ✅ 测试工程师 E2E 框架搭建完毕
- ✅ CDK Stack 可编译

如未达成，启动应急方案：
- 砍掉 Story 3, 4，集中力量确保 Story 1, 2 + 测试完整
