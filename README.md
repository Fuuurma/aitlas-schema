# aitlas-schema

**Shared database schemas for all Aitlas projects.**

## Why

Multiple Aitlas projects (nexus, f.code, backend-template, agent-store) were creating duplicate tables with different naming conventions. This package provides:

1. **Canonical schemas** - Single source of truth for data models
2. **Multi-format support** - Prisma (TypeScript) + Drizzle (TypeScript) + Ecto (Elixir)
3. **Migration history** - All migrations in one place

## Installation

```bash
# npm
npm install @aitlas/schema

# pnpm
pnpm add @aitlas/schema
```

## Usage

### Prisma (TypeScript/Node)

```prisma
// in your prisma/schema.prisma
import "./node_modules/@aitlas/schema/prisma/base.prisma"
```

Or copy the schema:

```bash
cp node_modules/@aitlas/schema/prisma/base.prisma ./prisma/schema.prisma
```

### Drizzle (TypeScript/Node)

```typescript
// Import all schemas
import * as schema from "@aitlas/schema/drizzle";

// Or import specific tables
import { users, tasks, agents } from "@aitlas/schema/drizzle";

// Use with drizzle-orm
import { drizzle } from "drizzle-orm/neon-serverless";
import { Pool } from "@neondatabase/serverless";
import * as schema from "@aitlas/schema/drizzle";

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
export const db = drizzle(pool, { schema });
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

## Current Tables (44 total)

### Auth & Users (6 tables)
| Table | Purpose |
|-------|---------|
| `users` | User accounts with credits |
| `sessions` | Auth sessions |
| `accounts` | OAuth accounts |
| `verifications` | Email verification tokens |
| `api_keys` | BYOK encrypted API keys |
| `credit_ledger` | Credit transaction history |

### AI Providers (2 tables)
| Table | Purpose |
|-------|---------|
| `providers` | AI providers (OpenAI, Anthropic, etc.) |
| `models` | AI models with pricing |

### Agents (5 tables)
| Table | Purpose |
|-------|---------|
| `agents` | Agent templates |
| `agent_skills` | Agent skill configurations |
| `agent_mcp_tools` | MCP tool registry |
| `agent_actions` | Agent action definitions |
| `installed_agents` | User-installed agents |
| `user_agents` | User-defined agents |

### Tasks (4 tables)
| Table | Purpose |
|-------|---------|
| `tasks` | Agent task execution |
| `task_steps` | Task execution steps |
| `tool_calls` | Tool execution logs |
| `execution_logs` | Debug logs |

### Skills (2 tables)
| Table | Purpose |
|-------|---------|
| `skills` | Skill definitions |
| `skill_executions` | Skill execution history |

### MCP (3 tables)
| Table | Purpose |
|-------|---------|
| `mcp_servers` | MCP server configurations |
| `mcp_tools` | MCP tool definitions |
| `mcp_resources` | MCP resource registry |

### Billing (3 tables)
| Table | Purpose |
|-------|---------|
| `plans` | Subscription plans |
| `subscriptions` | User subscriptions |
| `credit_rates` | Per-model credit rates |

### Webhooks (2 tables)
| Table | Purpose |
|-------|---------|
| `webhooks` | Webhook configurations |
| `webhook_deliveries` | Delivery history |

### Features (2 tables)
| Table | Purpose |
|-------|---------|
| `feature_flags` | Feature flag definitions |
| `user_feature_flags` | User-specific overrides |

### Prompts (2 tables)
| Table | Purpose |
|-------|---------|
| `system_prompts` | System prompt templates |
| `prompt_templates` | Reusable prompt templates |

### Workflows (2 tables)
| Table | Purpose |
|-------|---------|
| `workflows` | DAG workflow definitions |
| `workflow_executions` | Workflow execution history |

### Memory (3 tables)
| Table | Purpose |
|-------|---------|
| `memory_episodes` | Episodic memory |
| `memory_knowledge` | Knowledge base |
| `memory_embeddings` | Vector embeddings |

### Audit (1 table)
| Table | Purpose |
|-------|---------|
| `audit_logs` | Audit trail |

### Oban (2 tables)
| Table | Purpose |
|-------|---------|
| `oban_jobs` | Oban job queue |
| `oban_peers` | Oban peer registry |

### Other (3 tables)
| Table | Purpose |
|-------|---------|
| `schema_migrations` | Migration history |
| `research_history` | Research logs |
| `scheduled_research` | Scheduled research |

## Migration Strategy

1. All new migrations go in `/migrations/`
2. Use timestamp prefix: `YYYYMMDDHHMMSS_description.sql`
3. Prisma, Drizzle, and Ecto migrations must be kept in sync

## Development

```bash
# Generate Prisma client
pnpm generate

# Type check
pnpm typecheck

# Build
pnpm build
```

## Version History

- **0.2.0** - Added Drizzle support, expanded to 44 tables
- **0.1.0** - Initial release with Prisma schemas