# Aitlas Complete Database Schema

**Version:** 2026-03-12
**Total Tables:** 44
**Database:** PostgreSQL 15 + pgvector (Neon)

---

## Table Summary by Category

| Category | Tables | Purpose |
|----------|--------|---------|
| **Auth & Users** | 4 | Authentication, sessions, accounts |
| **Providers & Models** | 2 | AI provider and model registry |
| **Agents** | 3 | Agent management and versions |
| **System Prompts** | 2 | Reusable prompt templates |
| **Skills** | 3 | Agent capabilities system |
| **MCP** | 4 | Model Context Protocol integration |
| **Workflows** | 2 | DAG-based workflows |
| **Memory** | 3 | Episodic, semantic, vector embeddings |
| **Execution** | 4 | Tasks, steps, tool calls, logs |
| **Subscriptions** | 2 | Plans and billing |
| **Credits** | 2 | Credit ledger and rates |
| **Webhooks** | 2 | Event notifications |
| **Features** | 2 | Feature flags |
| **Audit** | 1 | Compliance logging |
| **Rate Limits** | 1 | API throttling |
| **Oban** | 3 | Job queue |

---

## Entity Relationship Diagram

```
Users ─┬─ Sessions
       ├─ Accounts
       ├─ API Keys
       ├─ User_Agents ────── Agents ─┬─ Agent_Versions
       │                            ├─ Agent_Skills ─── Skills
       │                            ├─ Agent_Actions
       │                            └─ Agent_MCP_Tools ─── MCP_Tools ─── MCP_Servers
       ├─ Installed_Agents
       ├─ Tasks ─┬─ Task_Steps
       │         ├─ Tool_Calls
       │         ├─ Execution_Logs
       │         └─ Skill_Executions
       ├─ Subscriptions ─────── Plans
       ├─ Credit_Ledger
       ├─ Webhooks ──────────── Webhook_Deliveries
       ├─ User_Feature_Flags ── Feature_Flags
       └─ Memory_Episodes
          Memory_Knowledge

Providers ─── Models ─── Credit_Rates

Workflows ─── Workflow_Executions

MCP_Servers ─┬─ MCP_Tools
             └─ MCP_Resources

System_Prompts
Prompt_Templates
Rate_Limits
Audit_Logs
```

---

## All Tables (44)

### Authentication & Users

| Table | Description | Key Fields |
|-------|-------------|------------|
| `users` | User accounts | id, email, name, plan_tier, compute_credits |
| `sessions` | Auth sessions | id, user_id, expires_at |
| `accounts` | OAuth accounts | id, user_id, provider |
| `api_keys` | API key management | id, user_id, key_hash, scopes |

### AI Providers & Models

| Table | Description | Key Fields |
|-------|-------------|------------|
| `providers` | AI provider registry | id, name, base_url, rate_limit_rpm |
| `models` | Model registry | id, provider_id, context_window, costs |

**Seeded Data:**
- 8 providers: OpenAI, Anthropic, Google, OpenRouter, Groq, DeepSeek, Bailian, MiniMax
- 18 models: GPT-4o, Claude 3.5, Gemini 2.0, Llama 3.3, Qwen, etc.

### Agents

| Table | Description | Key Fields |
|-------|-------------|------------|
| `agents` | Agent definitions | id, name, category, risk_level, system_prompt |
| `user_agents` | User-installed agents | user_id, agent_id, config |
| `agent_versions` | Version history | agent_id, version, system_prompt, changelog |

### Skills System

| Table | Description | Key Fields |
|-------|-------------|------------|
| `skills` | Skill definitions | id, name, category, required_tools |
| `agent_skills` | Agent-skill mapping | agent_id, skill_id |
| `skill_executions` | Execution history | skill_id, task_id, input, output |

**Seeded Skills:** web_search, code_generation, memory_search, data_analysis, web_scraping

### MCP (Model Context Protocol)

| Table | Description | Key Fields |
|-------|-------------|------------|
| `mcp_servers` | MCP server configs | id, name, transport, command |
| `mcp_tools` | Available tools | server_id, name, input_schema |
| `mcp_resources` | Available resources | server_id, uri, mime_type |
| `agent_mcp_tools` | Agent-MCP tool mapping | agent_id, tool_id |

**Seeded MCP Servers:** filesystem, postgres, github, brave-search, slack, google-maps

### Prompts

| Table | Description | Key Fields |
|-------|-------------|------------|
| `system_prompts` | Agent system prompts | id, name, content, category |
| `prompt_templates` | Reusable templates | id, name, template, variables |

**Seeded Prompts:** default-agent, coder, researcher, analyst, architect

### Workflows

| Table | Description | Key Fields |
|-------|-------------|------------|
| `workflows` | Workflow definitions | id, name, definition (DAG), triggers |
| `workflow_executions` | Execution history | workflow_id, status, input, output |

### Memory

| Table | Description | Key Fields |
|-------|-------------|------------|
| `memory_episodes` | Episodic memory | id, user_id, task_id, content |
| `memory_knowledge` | Semantic memory | id, user_id, key, value |
| `memory_embeddings` | Vector embeddings | id, memory_type, embedding (vector 1536) |

### Task Execution

| Table | Description | Key Fields |
|-------|-------------|------------|
| `tasks` | Task execution | id, user_id, agent_slug, goal, status |
| `task_steps` | Step history | task_id, step_number, action, result |
| `tool_calls` | Tool call logs | task_id, tool_name, arguments, result |
| `execution_logs` | Detailed logs | task_id, level, message, metadata |

### Subscriptions & Billing

| Table | Description | Key Fields |
|-------|-------------|------------|
| `plans` | Subscription plans | id, name, price_monthly, credits_included |
| `subscriptions` | User subscriptions | user_id, plan_id, status, stripe_subscription_id |
| `credit_ledger` | Credit transactions | user_id, delta, balance, reason |
| `credit_rates` | Token costs | model_id, input_cost_per_token |

**Seeded Plans:** Free (100 credits), Starter ($9.99), Pro ($29.99), Team ($79.99), Enterprise (custom)

### Webhooks

| Table | Description | Key Fields |
|-------|-------------|------------|
| `webhooks` | Webhook configs | user_id, url, events |
| `webhook_deliveries` | Delivery history | webhook_id, event_type, payload |

### Feature Flags

| Table | Description | Key Fields |
|-------|-------------|------------|
| `feature_flags` | Flag definitions | name, enabled, rollout_percentage |
| `user_feature_flags` | User overrides | user_id, flag_id, enabled |

### Audit & Rate Limiting

| Table | Description | Key Fields |
|-------|-------------|------------|
| `audit_logs` | Compliance logs | user_id, action, resource_type, old/new_values |
| `rate_limits` | Token bucket | key, tokens, last_refill |

### Oban (Job Queue)

| Table | Description |
|-------|-------------|
| `oban_jobs` | Background jobs |
| `oban_peers` | Cluster coordination |
| `schema_migrations` | Migration tracking |

---

## Indexes

All tables have appropriate indexes:

- **Primary keys:** All tables have `id` as PRIMARY KEY
- **Foreign keys:** Indexed for JOIN performance
- **Search indexes:** name, status, created_at, user_id
- **Vector index:** IVFFlat on memory_embeddings.embedding

---

## Relationships

### User-Centric
```
users 1:N sessions
users 1:N accounts
users 1:N api_keys
users 1:N tasks
users 1:N subscriptions
users 1:N webhooks
users 1:N memory_episodes
users 1:N credit_ledger
```

### Agent-Centric
```
agents 1:N user_agents
agents 1:N agent_versions
agents N:M skills (via agent_skills)
agents 1:N agent_actions
agents N:M mcp_tools (via agent_mcp_tools)
```

### Task-Centric
```
tasks 1:N task_steps
tasks 1:N tool_calls
tasks 1:N execution_logs
tasks 1:N skill_executions
tasks 1:N memory_episodes
tasks N:1 agents (via agent_slug)
```

### MCP-Centric
```
mcp_servers 1:N mcp_tools
mcp_servers 1:N mcp_resources
mcp_tools N:M agents (via agent_mcp_tools)
```

---

## Seed Data Summary

| Category | Count |
|----------|-------|
| Providers | 8 |
| Models | 18 |
| Plans | 5 |
| Skills | 5 |
| MCP Servers | 6 |
| System Prompts | 5 |
| Prompt Templates | 4 |
| Credit Rates | 8 |
| Feature Flags | 6 |

---

## Next Steps

1. **Integrate with Nexus** - Update Prisma schema
2. **Integrate with Nova** - Update Ecto schema
3. **Integrate with Agent Store** - Link agents table
4. **Integrate with Actions** - Link skills/MCP tables
5. **Add indexes** for specific query patterns
6. **Create migrations** for Elixir/Prisma

---

## Connection

```bash
# Pooled (for app)
postgresql://neondb_owner:npg_XXX@ep-XXX-pooler.eu-west-2.aws.neon.tech/neondb?sslmode=require

# Unpooled (for migrations)
postgresql://neondb_owner:npg_XXX@ep-XXX.eu-west-2.aws.neon.tech/neondb?sslmode=require
```

---

*Generated: 2026-03-12 02:30 Europe/Madrid*