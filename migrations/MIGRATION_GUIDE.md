# Migration Guide

## Current State (2026-03-12)

The Neon database has **35 tables** with duplicate schemas from different projects:

| Elixir (snake_case) | Prisma (PascalCase) |
|---------------------|---------------------|
| `users` | `user` |
| `sessions` | `session` |
| `accounts` | `account` |
| `tasks` | `Task` |
| `agents` | `Agent` |
| `api_keys` | `ApiKey` |
| `credit_ledger` | `CreditLedgerEntry` |

## Migration Steps

### Step 1: Drop PascalCase Tables

```sql
-- Run in Neon SQL editor
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS "session" CASCADE;
DROP TABLE IF EXISTS "account" CASCADE;
DROP TABLE IF EXISTS "verification" CASCADE;
DROP TABLE IF EXISTS "verifications" CASCADE;
DROP TABLE IF EXISTS "Agent" CASCADE;
DROP TABLE IF EXISTS "Task" CASCADE;
DROP TABLE IF EXISTS "Event" CASCADE;
DROP TABLE IF EXISTS "Memory" CASCADE;
DROP TABLE IF EXISTS "MCPRegistry" CASCADE;
DROP TABLE IF EXISTS "ToolRegistry" CASCADE;
DROP TABLE IF EXISTS "UserAgent" CASCADE;
DROP TABLE IF EXISTS "ApiKey" CASCADE;
DROP TABLE IF EXISTS "CreditLedgerEntry" CASCADE;
DROP TABLE IF EXISTS "CreditReservation" CASCADE;
```

### Step 2: Update f.code to use snake_case

In `prisma/schema.prisma`:

1. Add `@@map("users")` to User model
2. Add `@@map("sessions")` to Session model
3. Add `@@map("tasks")` to Task model
4. Add `@@map("api_keys")` to ApiKey model
5. Use `@map("column_name")` for snake_case columns

### Step 3: Regenerate Prisma Client

```bash
cd aitlas-f.code
bunx prisma generate
bunx prisma db pull  # Sync from DB
```

### Step 4: Test Connections

```bash
# Test nexus
cd aitlas-nexus && mix ecto.migrate

# Test f.code
cd aitlas-f.code && bunx prisma db push
```

## Rollback Plan

If migration fails, the PascalCase tables are still in backup. Restore from:

1. Neon branching feature
2. Daily automatic backups