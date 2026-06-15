# Test Strategy: Hotel Booking Inventory API

> 预填版本 — Workshop 应急使用

## 测试金字塔

```
        /  E2E  \           (3-5 个关键场景)
       / Integration \      (每个 DynamoDB 操作)
      /   Unit Tests   \    (每个 Handler)
```

## 工具链

| 类型 | 工具 | 用途 |
|------|------|------|
| 单元测试 | Jest | Handler 逻辑 |
| Mock | aws-sdk-client-mock | DynamoDB 操作模拟 |
| E2E | Jest + supertest | HTTP 端到端 |
| 本地 DB | DynamoDB Local | 集成测试环境 |
| 覆盖率 | Jest --coverage | 目标 > 80% |

## 单元测试用例

### create-room.test.ts

| 场景 | 输入 | 期望 |
|------|------|------|
| 创建成功 | 有效房间数据 | 201 + 房间对象含 id |
| 缺少必填字段 | 无 hotelId | 400 + VALIDATION_ERROR |
| 无效类型 | type="unknown" | 400 + VALIDATION_ERROR |
| 价格为负 | pricePerNight=-1 | 400 + VALIDATION_ERROR |
| DynamoDB 失败 | 模拟写入异常 | 500 + INTERNAL_ERROR |

### get-room.test.ts

| 场景 | 输入 | 期望 |
|------|------|------|
| 获取成功 | 存在的 roomId | 200 + 房间对象 |
| 不存在 | 随机 UUID（从未创建） | 404 + NOT_FOUND |
| 已归档 | 已 DELETE（软删除）的 roomId | 410 + GONE，响应体含 archivedAt |
| 无效 ID 格式 | "abc" | 400 + VALIDATION_ERROR |

### update-room.test.ts

| 场景 | 输入 | 期望 |
|------|------|------|
| 更新成功 | 有效字段 | 200 + 更新后的房间对象 |
| 不存在 | 随机 UUID | 404 + NOT_FOUND |
| 无效字段 | pricePerNight=-1 | 400 + VALIDATION_ERROR |

### archive-room.test.ts（软删除，可选端点）

| 场景 | 输入 | 期望 |
|------|------|------|
| 归档成功 | 存在的 roomId | 200/204，status→archived 且写入 archivedAt |
| 再次访问已归档 | 已归档的 roomId（GET） | 410 + GONE，响应体含 archivedAt |
| 归档不存在的房间 | 随机 UUID | 404 + NOT_FOUND |

### list-rooms.test.ts

| 场景 | 输入 | 期望 |
|------|------|------|
| 列出成功 | hotelId 有房间 | 200 + 数组 |
| 空列表 | hotelId 无房间 | 200 + 空数组 |
| 分页 | limit=2 | 200 + 2 条 + nextToken |

### check-availability.test.ts

| 场景 | 输入 | 期望 |
|------|------|------|
| 有可用 | 未预订日期范围 | 200 + available: true |
| 已满 | 全部预订的日期 | 200 + available: false |
| 无效日期 | end < start | 400 + VALIDATION_ERROR |

## E2E 测试场景

### 完整流程

```
1. POST /rooms → 创建房间 → 记录 roomId
2. GET /rooms/{roomId} → 确认数据一致
3. GET /rooms → 确认在列表中
4. PUT /rooms/{roomId} → 更新价格 → 确认生效
5. GET /rooms/availability?start=2026-07-01&end=2026-07-03 → 可用
6. DELETE /rooms/{roomId} → 归档 → GET /rooms/{roomId} 返回 410 Gone（含 archivedAt）
```

### 认证流程

```
1. 无 Token → GET /rooms → 401
2. 过期 Token → GET /rooms → 401
3. 有效 Token → GET /rooms → 200
```

### 错误处理

```
1. POST /rooms + 无效 body → 400
2. GET /rooms/not-exist-id → 404（房间从未存在）
3. GET /rooms/{archived-id} → 410 Gone（房间已归档，含 archivedAt）
4. POST /rooms + 超长字段 → 400
```

:::alert{type="info"}
**404 vs 410 的区分**是本 API 的关键验收点：404 表示"房间从未存在",410 Gone 表示"房间曾存在、已被软删除（归档）"。这正是 Review Gate #1 中"删除语义"对齐决策落到测试侧的体现——PRD（端点语义为归档）、架构（软删除 + 410）、测试策略三者必须一致。
:::

## 质量门禁

| 指标 | 阈值 | 阻断 |
|------|------|------|
| 单元测试通过率 | 100% | 是 |
| 覆盖率 (lines) | > 80% | 是 |
| E2E 关键场景 | 全部通过 | 是 |
| 性能 P95 | < 500ms | 否 (记录但不阻断) |
