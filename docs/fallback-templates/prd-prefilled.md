# PRD: Hotel Booking Inventory API

> 预填版本 — Workshop 应急使用

## 产品概述

Hotel Booking Inventory API 是一个 RESTful 微服务，提供酒店房间库存管理能力，包括房间 CRUD 操作和可用性查询。

## 目标用户

- 酒店管理后台系统
- OTA (Online Travel Agency) 集成合作伙伴
- 内部运营团队

## 功能需求

### P0 — 必须实现

| # | 功能 | 端点 | 描述 |
|---|------|------|------|
| 1 | 创建房间 | POST /api/v1/rooms | 添加新房间到库存 |
| 2 | 获取房间 | GET /api/v1/rooms/{id} | 查询单个房间详情 |
| 3 | 列出房间 | GET /api/v1/rooms | 分页列出所有房间 |
| 4 | 查询可用性 | GET /api/v1/rooms/{id}/availability | 查询指定日期范围可用性 |

### P1 — 如有时间

| # | 功能 | 端点 | 描述 |
|---|------|------|------|
| 5 | 更新房间 | PUT /api/v1/rooms/{id} | 更新房间信息 |
| 6 | 删除房间 | DELETE /api/v1/rooms/{id} | 下架房间 |

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
  "status": "active | inactive",
  "createdAt": "2026-01-01T00:00:00Z",
  "updatedAt": "2026-01-01T00:00:00Z"
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

- [ ] 所有 P0 端点可通过 HTTP 调用
- [ ] 输入验证：非法数据返回 400
- [ ] 认证：无 token 返回 401
- [ ] 单元测试覆盖率 > 80%
- [ ] 代码通过 lint 检查
