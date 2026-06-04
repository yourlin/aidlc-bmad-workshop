# Architecture 阶段通用模板

> 适用于 AWS 项目的架构设计 Prompt 模式

## 创建架构文档

```
/bmad-agent-architect

CA

Create the technical architecture for [PROJECT_NAME].

AWS Stack:
- Compute: [Lambda / ECS / EC2]
- API: [API Gateway REST / HTTP / AppSync]
- Database: [DynamoDB / Aurora / ElastiCache]
- Auth: [Cognito / Lambda Authorizer / IAM]
- Storage: [S3]
- Messaging: [SQS / SNS / EventBridge]
- IaC: [CDK / CloudFormation / Terraform]

Requirements:
- [SCALABILITY REQUIREMENT]
- [SECURITY REQUIREMENT]
- [COST REQUIREMENT]
- [OBSERVABILITY REQUIREMENT]

Design deliverables:
1. System context diagram (C4 level 1)
2. Component diagram (C4 level 2)
3. Database schema / access patterns
4. API route inventory
5. IAM permission matrix
6. Monitoring & alerting plan

Output: _bmad-output/planning-artifacts/architecture.md
```

## CDK 基础设施设计

```
/bmad-agent-architect

CI

Create CDK infrastructure code.

Based on architecture at _bmad-output/planning-artifacts/architecture.md.

Stack decomposition:
1. [StackName]Stack — [WHAT IT CONTAINS]
2. [StackName]Stack — [WHAT IT CONTAINS]
3. [StackName]Stack — [WHAT IT CONTAINS]

Requirements:
- CDK v2 + TypeScript
- Environment parameter (dev/staging/prod)
- Outputs for cross-stack references
- Tags for cost allocation
- Removal policies appropriate per environment

Output: src/infra/
```

## 架构评审 Prompt（Party Mode）

```
Start Party Mode with Winston and Quinn.

Review the architecture document for:
1. Does it cover all PRD requirements?
2. Are DynamoDB access patterns complete for all use cases?
3. Is IAM following least privilege?
4. Are there single points of failure?
5. Is the monitoring plan sufficient for production?
6. Cost estimation: is this reasonable for the expected scale?
7. Security: any OWASP concerns?
```

## Brownfield 架构扩展

```
/bmad-agent-architect

CA

Extend existing AWS architecture for [NEW_FEATURE].

Current system (DO NOT CHANGE):
- [EXISTING_SERVICE_1]: [WHAT IT DOES]
- [EXISTING_SERVICE_2]: [WHAT IT DOES]
- [EXISTING_DATABASE]: [SCHEMA SUMMARY]

Design the EXTENSION:
- New [SERVICE_TYPE]: [WHAT IT DOES]
- New DB entities: [DESCRIBE NEW ACCESS PATTERNS]
- Integration with existing: [HOW NEW CONNECTS TO OLD]

Constraints:
- Zero downtime deployment
- Backward compatible
- Same region, same VPC (if applicable)

Output: Architecture DELTA document (what CHANGES, what STAYS)
```
