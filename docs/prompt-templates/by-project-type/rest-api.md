# AWS RESTful API 项目模板 (API Gateway + Lambda + DynamoDB)

## PM — 创建 PRD

```
CP

Create a PRD for [PROJECT_NAME].

Project type: RESTful API microservice
Endpoints:
- [LIST YOUR ENDPOINTS, e.g.:]
- POST /api/v1/[resource] (create)
- GET /api/v1/[resource]/{id} (read)
- GET /api/v1/[resource] (list with pagination)
- PUT /api/v1/[resource]/{id} (update)
- DELETE /api/v1/[resource]/{id} (delete)

Focus on:
- Input/output schemas for each endpoint
- Authentication and authorization requirements
- Error response format standards
- Pagination and filtering strategy
- Rate limiting requirements

Constraints:
- [TIME_CONSTRAINT] time limit
- MVP scope: [describe minimum viable endpoints]

Output: _bmad-output/planning-artifacts/prd.md
```

## Architect — 创建架构

```
CA

Create the technical architecture for [PROJECT_NAME].

Stack: [TECH_STACK]
Requirements:
- RESTful API design principles (resource-oriented URLs)
- [DATABASE] for persistence
- [AUTH_METHOD] for authentication
- Input validation layer (Zod/Joi/class-validator)
- Structured error handling with consistent format
- Health check endpoint
- Request/response logging

Design decisions needed:
- Database schema (tables/collections/access patterns)
- API versioning strategy (URL path vs header)
- Middleware pipeline (auth → validate → handler → error)
- Deployment topology

Output: Architecture document + project structure diagram
```

## Developer — 实现 Story

```
DS

Implement the "[STORY_NAME]" endpoint.

Tech: [TECH_STACK]
Requirements:
- [HTTP_METHOD] /api/v1/[path]
- Input validation ([VALIDATION_LIBRARY] schema)
- [DATABASE] operation ([CRUD_OPERATION])
- Unit tests ([TEST_FRAMEWORK])
- Follow TDD: write test first, then implement
- Follow existing code patterns from [REFERENCE_FILE]

Error cases to handle:
- 400: Invalid input
- 401: Unauthorized
- 404: Resource not found (for GET/PUT/DELETE)
- 409: Conflict (for create with duplicate key)
- 500: Internal server error

Keep code clean and minimal.
```

## QA — 测试策略

```
TS

Generate test strategy for [PROJECT_NAME] REST API.

Coverage:
- Unit tests for each endpoint handler
- Integration tests for database operations
- API contract tests (request/response schema validation)
- Authentication tests (valid token, expired, missing)
- Edge cases: empty body, invalid types, oversized payload
- Pagination boundary tests

Tools: [TEST_FRAMEWORK] + [HTTP_TEST_LIBRARY, e.g. supertest]
Output: Test strategy document with priority matrix
```

## Test Architect — E2E 测试

```
E2E

Create end-to-end tests for [PROJECT_NAME].

Stack: [TEST_FRAMEWORK] + [HTTP_CLIENT]
Scenarios:
1. Full CRUD flow: create → read → update → delete
2. Auth flow: login → access protected → logout
3. Error handling: invalid input → proper error response
4. Pagination: create N items → paginate through them

Test environment:
- [LOCAL_DB_SETUP, e.g. DynamoDB Local / Docker PostgreSQL]
- Base URL: http://localhost:[PORT]

Output: src/__tests__/e2e/
```
