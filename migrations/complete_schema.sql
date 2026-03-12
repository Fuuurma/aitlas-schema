-- Aitlas Complete Schema - AI Computing Backbone
-- Version: 2026-03-12
-- Database: PostgreSQL + pgvector

-- ============================================
-- Extensions
-- ============================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- ============================================
-- Core User & Auth (existing)
-- ============================================

-- users, sessions, accounts, api_keys (already exist)

-- ============================================
-- AI Provider & Model Registry
-- ============================================

CREATE TABLE providers (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  display_name VARCHAR(255),
  description TEXT,
  base_url VARCHAR(500),
  api_key_env VARCHAR(255),
  rate_limit_rpm INTEGER DEFAULT 60,
  rate_limit_tpm INTEGER DEFAULT 90000,
  enabled BOOLEAN DEFAULT true,
  config JSONB DEFAULT '{}',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE models (
  id VARCHAR(255) PRIMARY KEY,
  provider_id VARCHAR(255) NOT NULL REFERENCES providers(id),
  name VARCHAR(255) NOT NULL,
  display_name VARCHAR(255),
  context_window INTEGER DEFAULT 4096,
  max_output_tokens INTEGER DEFAULT 4096,
  input_cost_per_1k DECIMAL(10, 6) DEFAULT 0,
  output_cost_per_1k DECIMAL(10, 6) DEFAULT 0,
  supports_vision BOOLEAN DEFAULT false,
  supports_tools BOOLEAN DEFAULT false,
  supports_streaming BOOLEAN DEFAULT true,
  capabilities JSONB DEFAULT '[]',
  enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_models_provider ON models(provider_id);

-- ============================================
-- Agent System
-- ============================================

-- agents (exists, but let's define structure)
-- user_agents (exists)

CREATE TABLE agent_versions (
  id VARCHAR(255) PRIMARY KEY,
  agent_id VARCHAR(255) NOT NULL,
  version VARCHAR(50) NOT NULL,
  system_prompt TEXT NOT NULL,
  config JSONB DEFAULT '{}',
  changelog TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE
);

CREATE INDEX idx_agent_versions_agent ON agent_versions(agent_id);

CREATE TABLE system_prompts (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  content TEXT NOT NULL,
  variables JSONB DEFAULT '[]',
  category VARCHAR(100),
  tags JSONB DEFAULT '[]',
  version INTEGER DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_system_prompts_category ON system_prompts(category);

-- ============================================
-- Skills System
-- ============================================

-- agent_skills (exists)

CREATE TABLE skills (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  display_name VARCHAR(255),
  description TEXT,
  category VARCHAR(100),
  tags JSONB DEFAULT '[]',
  required_tools JSONB DEFAULT '[]',
  optional_tools JSONB DEFAULT '[]',
  config_schema JSONB DEFAULT '{}',
  default_config JSONB DEFAULT '{}',
  version VARCHAR(50) DEFAULT '1.0.0',
  enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_skills_category ON skills(category);

CREATE TABLE skill_executions (
  id VARCHAR(255) PRIMARY KEY,
  skill_id VARCHAR(255) NOT NULL REFERENCES skills(id),
  task_id VARCHAR(255) REFERENCES tasks(id),
  input JSONB NOT NULL,
  output JSONB,
  error TEXT,
  duration_ms INTEGER,
  success BOOLEAN,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_skill_executions_skill ON skill_executions(skill_id);
CREATE INDEX idx_skill_executions_task ON skill_executions(task_id);

-- ============================================
-- MCP (Model Context Protocol)
-- ============================================

-- agent_mcp_tools (exists)

CREATE TABLE mcp_servers (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  display_name VARCHAR(255),
  description TEXT,
  transport VARCHAR(50) NOT NULL, -- 'stdio', 'http', 'websocket'
  command VARCHAR(500),
  args JSONB DEFAULT '[]',
  env JSONB DEFAULT '{}',
  url VARCHAR(500),
  enabled BOOLEAN DEFAULT true,
  auto_start BOOLEAN DEFAULT false,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE mcp_tools (
  id VARCHAR(255) PRIMARY KEY,
  server_id VARCHAR(255) NOT NULL REFERENCES mcp_servers(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  input_schema JSONB NOT NULL,
  output_schema JSONB,
  annotations JSONB DEFAULT '{}',
  enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE(server_id, name)
);

CREATE INDEX idx_mcp_tools_server ON mcp_tools(server_id);

CREATE TABLE mcp_resources (
  id VARCHAR(255) PRIMARY KEY,
  server_id VARCHAR(255) NOT NULL REFERENCES mcp_servers(id),
  uri VARCHAR(500) NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  mime_type VARCHAR(100),
  size_bytes BIGINT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE(server_id, uri)
);

CREATE INDEX idx_mcp_resources_server ON mcp_resources(server_id);

-- ============================================
-- Prompts & Templates
-- ============================================

CREATE TABLE prompt_templates (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  template TEXT NOT NULL,
  variables JSONB DEFAULT '[]',
  category VARCHAR(100),
  tags JSONB DEFAULT '[]',
  version INTEGER DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_prompt_templates_category ON prompt_templates(category);

-- ============================================
-- Workflows
-- ============================================

CREATE TABLE workflows (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  definition JSONB NOT NULL, -- DAG definition
  triggers JSONB DEFAULT '[]',
  input_schema JSONB DEFAULT '{}',
  output_schema JSONB DEFAULT '{}',
  enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE workflow_executions (
  id VARCHAR(255) PRIMARY KEY,
  workflow_id VARCHAR(255) NOT NULL REFERENCES workflows(id),
  user_id VARCHAR(255) REFERENCES users(id),
  status VARCHAR(50) NOT NULL DEFAULT 'pending',
  input JSONB NOT NULL,
  output JSONB,
  error TEXT,
  current_step VARCHAR(255),
  context JSONB DEFAULT '{}',
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_workflow_executions_workflow ON workflow_executions(workflow_id);
CREATE INDEX idx_workflow_executions_user ON workflow_executions(user_id);
CREATE INDEX idx_workflow_executions_status ON workflow_executions(status);

-- ============================================
-- Memory & Context (existing)
-- ============================================

-- memory_episodes, memory_knowledge (exist)

CREATE TABLE memory_embeddings (
  id VARCHAR(255) PRIMARY KEY,
  memory_type VARCHAR(50) NOT NULL, -- 'episode', 'knowledge', 'task'
  memory_id VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  embedding vector(1536),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_memory_embeddings_type ON memory_embeddings(memory_type);
CREATE INDEX idx_memory_embeddings_vector ON memory_embeddings USING ivfflat (embedding vector_cosine_ops);

-- ============================================
-- Execution & Observability
-- ============================================

-- tasks, task_steps, tool_calls (exist)

CREATE TABLE execution_logs (
  id VARCHAR(255) PRIMARY KEY,
  task_id VARCHAR(255) REFERENCES tasks(id),
  agent_id VARCHAR(255),
  level VARCHAR(20) NOT NULL, -- 'debug', 'info', 'warning', 'error'
  message TEXT NOT NULL,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_execution_logs_task ON execution_logs(task_id);
CREATE INDEX idx_execution_logs_level ON execution_logs(level);
CREATE INDEX idx_execution_logs_created ON execution_logs(created_at DESC);

-- ============================================
-- Credits & Billing (existing)
-- ============================================

-- credit_ledger (exists)

CREATE TABLE credit_rates (
  id VARCHAR(255) PRIMARY KEY,
  model_id VARCHAR(255) REFERENCES models(id),
  input_cost_per_token DECIMAL(10, 8) NOT NULL,
  output_cost_per_token DECIMAL(10, 8) NOT NULL,
  effective_from TIMESTAMP NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_credit_rates_model ON credit_rates(model_id);

-- ============================================
-- Webhooks & Events
-- ============================================

CREATE TABLE webhooks (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL REFERENCES users(id),
  name VARCHAR(255) NOT NULL,
  url VARCHAR(500) NOT NULL,
  secret VARCHAR(255),
  events JSONB NOT NULL DEFAULT '[]',
  enabled BOOLEAN DEFAULT true,
  last_triggered_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_webhooks_user ON webhooks(user_id);

CREATE TABLE webhook_deliveries (
  id VARCHAR(255) PRIMARY KEY,
  webhook_id VARCHAR(255) NOT NULL REFERENCES webhooks(id),
  event_type VARCHAR(100) NOT NULL,
  payload JSONB NOT NULL,
  response_status INTEGER,
  response_body TEXT,
  attempts INTEGER DEFAULT 0,
  delivered_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_webhook_deliveries_webhook ON webhook_deliveries(webhook_id);

-- ============================================
-- Feature Flags & Configuration
-- ============================================

CREATE TABLE feature_flags (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  description TEXT,
  enabled BOOLEAN DEFAULT false,
  rollout_percentage INTEGER DEFAULT 0,
  conditions JSONB DEFAULT '{}',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE user_feature_flags (
  user_id VARCHAR(255) REFERENCES users(id),
  flag_id VARCHAR(255) REFERENCES feature_flags(id),
  enabled BOOLEAN NOT NULL,
  PRIMARY KEY (user_id, flag_id)
);

-- ============================================
-- Audit & Compliance
-- ============================================

CREATE TABLE audit_logs (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) REFERENCES users(id),
  action VARCHAR(100) NOT NULL,
  resource_type VARCHAR(100),
  resource_id VARCHAR(255),
  old_values JSONB,
  new_values JSONB,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at DESC);

-- ============================================
-- Rate Limiting
-- ============================================

CREATE TABLE rate_limits (
  id VARCHAR(255) PRIMARY KEY,
  key VARCHAR(255) NOT NULL UNIQUE,
  tokens INTEGER NOT NULL DEFAULT 0,
  last_refill TIMESTAMP NOT NULL DEFAULT NOW(),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_rate_limits_key ON rate_limits(key);

-- ============================================
-- Summary: Table Count
-- ============================================

-- Total: 40+ tables for complete AI computing backbone
-- 
-- Categories:
-- - Auth & Users: 4 tables (users, sessions, accounts, api_keys)
-- - Providers & Models: 2 tables (providers, models)
-- - Agents: 3 tables (agents, user_agents, agent_versions)
-- - Prompts: 2 tables (system_prompts, prompt_templates)
-- - Skills: 3 tables (skills, skill_executions, agent_skills)
-- - MCP: 4 tables (mcp_servers, mcp_tools, mcp_resources, agent_mcp_tools)
-- - Workflows: 2 tables (workflows, workflow_executions)
-- - Memory: 3 tables (memory_episodes, memory_knowledge, memory_embeddings)
-- - Execution: 4 tables (tasks, task_steps, tool_calls, execution_logs)
-- - Credits: 2 tables (credit_ledger, credit_rates)
-- - Webhooks: 2 tables (webhooks, webhook_deliveries)
-- - Features: 2 tables (feature_flags, user_feature_flags)
-- - Audit: 1 table (audit_logs)
-- - Rate Limiting: 1 table (rate_limits)