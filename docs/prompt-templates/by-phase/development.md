# Development 阶段通用模板

> 适用于 AWS 项目的开发阶段 Prompt 模式

## 实现 Story（Dev Agent）

### 首个 Story

```
/bmad-agent-dev

DS

Implement the first story: "[STORY_NAME]".

Tech: [LANGUAGE] + [FRAMEWORK] + AWS SDK v3
Requirements:
- [ENDPOINT / FUNCTION DESCRIPTION]
- Input validation ([VALIDATION_LIBRARY])
- [DATABASE] operation ([SPECIFIC OPERATION])
- Unit tests ([TEST_FRAMEWORK])
- Follow TDD: write test first, then implement

Error cases to handle:
- [ERROR_1]: [RESPONSE]
- [ERROR_2]: [RESPONSE]
- [ERROR_3]: [RESPONSE]

Keep code clean and minimal.
```

### 后续 Story（开新 Session）

```
/bmad-agent-dev

DS

Implement story: "[STORY_NAME]".

Tech: [SAME AS ABOVE]
Requirements:
- [ENDPOINT / FUNCTION DESCRIPTION]
- [SPECIFIC REQUIREMENTS]
- Follow existing code patterns from [REFERENCE_FILE]
- Unit tests

Important: read existing code in [DIRECTORY] before writing new code.
```

### 继续未完成的 Story

```
/bmad-agent-dev

D2

Continue implementing "[STORY_NAME]".

What's done:
- [WHAT'S ALREADY IMPLEMENTED]

What's remaining:
- [WHAT NEEDS TO BE DONE]
- [SPECIFIC TESTS TO ADD]

Pick up from [FILE_PATH] and complete the implementation.
```

## Sprint 管理

### 查看 Sprint 进度

```
/bmad-agent-pm

SP

Based on the sprint plan at _bmad-output/planning-artifacts/sprint-plan.md,
assess current progress:
- Which stories are done? (check for test files + implementation)
- Which are in progress?
- Are we on track for the time box?
- Recommend: should we cut scope?
```

## 代码评审（Self-Review）

```
Start Party Mode with Amelia and Quinn.

Review the code I just wrote in [DIRECTORY]:
1. Does it follow existing patterns?
2. Are there any security issues?
3. Is error handling complete?
4. Are tests covering edge cases?
5. Any performance concerns?
```
