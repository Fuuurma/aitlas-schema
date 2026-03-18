import {
  pgTable,
  text,
  timestamp,
  boolean,
  integer,
  uuid,
  json,
  decimal,
} from "drizzle-orm/pg-core";
import { users } from "./users";

export const agents = pgTable("agents", {
  id: uuid("id").primaryKey(),
  name: text("name").notNull(),
  slug: text("slug").unique(),
  displayName: text("display_name"),
  description: text("description"),
  longDescription: text("long_description"),
  systemPrompt: text("system_prompt"),
  category: text("category").notNull(),
  categoryId: uuid("category_id"),
  role: text("role").default("assistant"),
  roleId: uuid("role_id"),
  tags: text("tags").array().default([]),
  currentVersion: text("current_version").default("1.0.0"),
  status: text("status").default("draft"),
  riskLevel: text("risk_level").notNull().default("unknown"),
  source: text("source"),
  sourceUrl: text("source_url"),
  stars: integer("stars").default(0),
  forks: integer("forks").default(0),
  runCount: integer("run_count").default(0),
  avgRating: decimal("avg_rating", { precision: 3, scale: 2 }),
  reviewCount: integer("review_count").default(0),
  successRate: decimal("success_rate", { precision: 5, scale: 2 }),
  imageUrl: text("image_url"),
  coverUrl: text("cover_url"),
  color: text("color"),
  emoji: text("emoji"),
  vibe: text("vibe"),
  author: text("author"),
  price: integer("price").default(0),
  isPublished: boolean("is_published").default(false),
  isFeatured: boolean("is_featured").default(false),
  isVerified: boolean("is_verified").default(false),
  featuredOrder: integer("featured_order"),
  version: text("version"),
  creatorId: uuid("creator_id"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const agentSkills = pgTable("agent_skills", {
  id: uuid("id").primaryKey(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  description: text("description"),
  instructions: text("instructions"),
  triggers: text("triggers").array().default([]),
  version: text("version"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const agentMcpTools = pgTable("agent_mcp_tools", {
  id: uuid("id").primaryKey(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  description: text("description"),
  inputSchema: json("input_schema").$type<Record<string, unknown>>(),
  creditCost: integer("credit_cost").default(0),
  isEnabled: boolean("is_enabled").default(true),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const agentActions = pgTable("agent_actions", {
  id: uuid("id").primaryKey(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  description: text("description"),
  mcpEndpoint: text("mcp_endpoint"),
  actionSchema: json("action_schema").$type<Record<string, unknown>>(),
  creditCost: integer("credit_cost").default(0),
  version: text("version"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const installedAgents = pgTable("installed_agents", {
  id: uuid("id").primaryKey(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  installedAt: timestamp("installed_at").notNull().defaultNow(),
  version: text("version"),
  isDefault: boolean("is_default").default(false),
  config: json("config").$type<Record<string, unknown>>().default({}),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const customAgents = pgTable("custom_agents", {
  id: text("id").primaryKey(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  description: text("description"),
  systemPrompt: text("system_prompt"),
  model: text("model").default("gpt-4o"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export type Agent = typeof agents.$inferSelect;
export type NewAgent = typeof agents.$inferInsert;
export type AgentSkill = typeof agentSkills.$inferSelect;
export type NewAgentSkill = typeof agentSkills.$inferInsert;
export type AgentMcpTool = typeof agentMcpTools.$inferSelect;
export type NewAgentMcpTool = typeof agentMcpTools.$inferInsert;
export type AgentAction = typeof agentActions.$inferSelect;
export type NewAgentAction = typeof agentActions.$inferInsert;
export type InstalledAgent = typeof installedAgents.$inferSelect;
export type NewInstalledAgent = typeof installedAgents.$inferInsert;
export type CustomAgent = typeof customAgents.$inferSelect;
export type NewCustomAgent = typeof customAgents.$inferInsert;