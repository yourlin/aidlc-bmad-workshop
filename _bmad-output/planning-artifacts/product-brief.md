# Product Brief: Hotel Booking Inventory API

## Overview
A RESTful API microservice for managing hotel room inventory,
supporting CRUD operations for room availability, pricing, and reservations.

## Target Users
- Hotel property management systems (PMS)
- Online travel agencies (OTA)
- Channel managers

## Core Features
1. Room inventory CRUD (create/read/update/delete)
2. Real-time availability queries
3. Rate plan management
4. JWT-based authentication
5. Webhook notifications for inventory changes

## Technical Constraints
- Serverless architecture (AWS Lambda)
- DynamoDB for data storage
- API Gateway for HTTP routing
- Response time < 200ms (p95)

## Success Criteria
- API coverage: 5 core endpoints
- Test coverage: > 80%
- Deployment: IaC (CDK/CloudFormation)
- Documentation: OpenAPI spec

## Scale
- Small project (MVP scope)
- Single-sprint delivery
