# PRD: Hotel Booking Inventory API

> 预填版本 — Workshop 应急使用

## 产品概述

Hotel Booking Inventory API 是一个 RESTful 微服务，提供酒店房间库存管理能力，包括房间 CRUD 操作和可用性查询。

## 目标用户

- 酒店管理后台系统
- OTA (Online Travel Agency) 集成合作伙伴
- 内部运营团队

## 功能需求

### 5 个核心端点（MVP 范围）

| # | 功能 | 端点 | 描述 |
|---|------|------|------|
| 1 | 创建房间 | POST /api/v1/rooms | 添加新房间到库存 |
| 2 | 获取房间 | GET /api/v1/rooms/{id} | 查询单个房间详情 |
| 3 | 列出房间 | GET /api/v1/rooms | 列出房间（支持 status/type 筛选） |
| 4 | 更新房间 | PUT /api/v1/rooms/{id} | 更新房间信息 |
| 5 | 查询可用性 | GET /api/v1/rooms/availability | 按日期范围查询可用性 |

### 可选端点 — 如有时间

| # | 功能 | 端点 | 描述 |
|---|------|------|------|
| 6 | 归档房间 | DELETE /api/v1/rooms/{id} | **软删除（归档）**：置 status=archived 并记录 archivedAt，不物理删除 |

:::alert{type="info"}
**关于"删除"语义：** 本 API 采用软删除——`DELETE /rooms/{id}` 的语义是"归档"而非物理删除。归档后再次 `GET` 该房间返回 **410 Gone（曾存在、已归档）并在响应体附 archivedAt 时间戳**；而 404 仅留给"从未存在"的房间 id。这是 Review Gate #1 中典型的跨文档语义对齐案例。
:::

## 数据模型

### Room

```json
{
  "id": "room-uuid",
  "hotelId": "hotel-uuid",
  "type": "standard | deluxe | suite",
  "name": "标准双床房 201",
  "capacity": 2,
  "pricePerNight": 299.00,
  "currency": "CNY",
  "amenities": ["wifi", "breakfast", "parking"],
  "status": "active | inactive | archived",
  "createdAt": "2026-01-01T00:00:00Z",
  "updatedAt": "2026-01-01T00:00:00Z",
  "archivedAt": null
}
```

## API 规范

### 创建房间

```
POST /api/v1/rooms
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "hotelId": "hotel-001",
  "type": "standard",
  "name": "标准双床房 201",
  "capacity": 2,
  "pricePerNight": 299.00,
  "currency": "CNY",
  "amenities": ["wifi", "breakfast"]
}

→ 201 Created
{
  "id": "room-xxx",
  ...created room data
}
```

### 错误响应格式

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "pricePerNight must be a positive number",
    "details": [...]
  }
}
```

## 非功能需求

| 维度 | 要求 |
|------|------|
| 延迟 | P95 < 200ms (冷启动除外) |
| 认证 | JWT (RS256), Lambda Authorizer |
| 日志 | 结构化 JSON, CloudWatch |
| 监控 | CloudWatch Alarms (5xx > 1%, P95 > 500ms) |

## 验收标准

- [ ] 5 个核心端点均可通过 HTTP 调用
- [ ] 输入验证：非法数据返回 400
- [ ] 认证：无 token 返回 401
- [ ] 不存在的房间 id：`GET /rooms/{id}` 返回 404
- [ ] 已归档房间：`GET /rooms/{id}` 返回 410 Gone，响应体含 archivedAt
- [ ] 单元测试覆盖率 > 80%
- [ ] 代码通过 lint 检查
