# 应急半成品模板 (Fallback Templates)

> 当 Workshop 时间不足时，讲师可直接发放这些预填模板，让学员跳过非核心阶段继续体验后续流程。

## 使用场景

| 情况 | 使用哪个模板 | 跳过什么 |
|------|-------------|---------|
| Inception 超时 | `prd-prefilled.md` + `architecture-prefilled.md` | PRD 和架构生成过程 |
| Sprint Planning 超时 | `sprint-plan-prefilled.md` | Story 拆分过程 |
| 开发超时 | `story1-implementation.md` | 第一个 Story 的实现 |
| 测试超时 | `test-strategy-prefilled.md` | 测试策略生成过程 |

## 讲师操作

```bash
# 将半成品模板复制到学员项目的输出目录
cp docs/fallback-templates/prd-prefilled.md _bmad-output/planning-artifacts/prd.md
cp docs/fallback-templates/architecture-prefilled.md _bmad-output/planning-artifacts/architecture.md
```

## 注意

- 这些模板基于 Hotel Booking Inventory API 项目
- 学员收到后应花 2 分钟快速阅读理解内容
- 让学员知道"跳过生成过程不等于跳过理解"
