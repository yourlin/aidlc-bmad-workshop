# 微型新手教程（5 分钟完整 AIDLC 体验）

> 讲师在 Workshop 开场使用，让学员快速体验一个完整的 AIDLC 周期
> 目的：建立信心 + 理解全流程 + 消除对 BMAD 复杂度的焦虑

---

## 讲师引导话术

"在正式开始之前，我们先用 5 分钟体验一下完整的 AIDLC 流程。这个极简示例会让你们感受到——从需求到代码，AI 可以多快完成。"

---

## 练习：给计算器添加一个百分比功能

### Step 1: 需求（1 分钟）

在 AI IDE 中输入：

```
我需要给一个计算器应用添加"百分比计算"功能。
用户输入一个数字，点击 % 按钮，得到该数字除以 100 的结果。
比如输入 50，点击 %，显示 0.5。

请用 2-3 句话帮我确认需求理解是否正确。
```

**讲师提示：** "看到了吗？你只用一句话描述需求，AI 就帮你确认理解。这就是 AIDLC 的 Inception 阶段。"

### Step 2: 实现（2 分钟）

确认后继续输入：

```
需求确认正确。请用 TypeScript 实现这个函数：
1. 先写一个测试（TDD）
2. 再写实现代码
3. 保持极简
```

AI 会产出类似：
```typescript
// test
describe('percentage', () => {
  it('should divide by 100', () => {
    expect(percentage(50)).toBe(0.5);
  });
});

// implementation
function percentage(value: number): number {
  return value / 100;
}
```

**讲师提示：** "这就是 Construction 阶段——AI 先写测试再写代码（TDD）。你看它多快？"

### Step 3: 评审（1 分钟）

继续输入：

```
请评审这段代码：
1. 有没有边界情况遗漏？
2. 输入 0、负数、非数字时会怎样？
```

AI 会指出边界情况并建议改进。

**讲师提示：** "这就是 Review Gate——AI 帮你发现问题。在正式 Workshop 中，我们还会用 Party Mode 让多个 AI 角色一起评审。"

### Step 4: 总结（30 秒）

**讲师话术：**

"刚才 5 分钟我们走完了：
- **Inception**：一句话需求 → AI 确认理解
- **Construction**：TDD 模式写代码
- **Review Gate**：AI 帮你发现问题

接下来的 Workshop，你们会用更完整的流程做一个真实项目。每个步骤都有专业化的 AI Agent 辅助——PM Agent 帮你写 PRD，Architect Agent 帮你设计架构，Dev Agent 帮你写代码。

**核心区别**：刚才是 Vibe Coding（快但没有文档），接下来是 AIDLC（有完整文档、可追溯、团队可协作）。"

---

## 关键教学目标

完成这个微型教程后，学员应该：

1. ✅ 感受到"从需求到代码可以很快"
2. ✅ 理解"TDD = 先写测试再实现"
3. ✅ 理解"Review Gate = 质量检查"
4. ✅ 对后续更完整的 Workshop 流程有心理准备
5. ✅ 明白 AIDLC 和 Vibe Coding 的区别
