# aitlas-schema

**Shared database schemas for all Aitlas projects.**

## Why

Multiple Aitlas projects (nexus, f.code, backend-template, agent-store) were creating duplicate tables with different naming conventions. This package provides:

1. **Canonical schemas** - Single source of truth for data models
2. **Multi-format support** - Prisma (TypeScript) + Ecto (Elixir)
3. **Migration history** - All migrations in one place

## Usage

### Prisma (TypeScript/Node)

```prisma
// in your prisma/schema.prisma
import "./node_modules/@aitlas/schema/prisma/base.prisma"
```

### Ecto (Elixir)

```elixir
# in your mix.exs
def deps do
  [
    {:aitlas_schema, github: "Fuuurma/aitlas-schema", subdir: "elixir"}
  ]
end
```

## Schema Convention

All tables use **snake_case** naming (PostgreSQL standard):

| Table | Purpose |
|-------|---------|
| `users` | User accounts |
| `sessions` | Auth sessions |
| `accounts` | OAuth accounts |
| `api_keys` | API key management |
| `tasks` | Agent tasks |
| `agents` | Agent definitions |
| `tool_calls` | Tool execution logs |
| `credit_ledger` | Credit transactions |

## Naming Rules

- **Tables:** snake_case (`users`, `api_keys`)
- **Columns:** snake_case (`email_verified`, `created_at`)
- **Indexes:** `{table}_{column}_idx` (`users_email_idx`)
- **Foreign keys:** `{table}_{column}_fkey` (`tasks_user_id_fkey`)

## Migration Strategy

1. All new migrations go in `/migrations/`
2. Use timestamp prefix: `YYYYMMDDHHMMSS_description.sql`
3. Both Prisma and Ecto migrations must be kept in sync

## Current Tables (2026-03-12)

See `migrations/current_schema.sql` for full schema.