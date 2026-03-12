// Agents
import { pgTable, text, timestamp, boolean, integer, uuid, json, } from "drizzle-orm/pg-core";
import { users } from "./users";
export const agents = pgTable("agents", {
    id: uuid("id").primaryKey(),
    name: text("name").notNull(),
    description: text("description"),
    systemPrompt: text("system_prompt"),
    category: text("category").notNull(),
    riskLevel: text("risk_level").notNull().default("unknown"),
    source: text("source"),
    sourceUrl: text("source_url"),
    stars: integer("stars").default(0),
    forks: integer("forks").default(0),
    imageUrl: text("image_url"),
    price: integer("price").default(0),
    isPublished: boolean("is_published").default(false),
    version: text("version"),
    color: text("color"),
    emoji: text("emoji"),
    vibe: text("vibe"),
    author: text("author"),
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
    inputSchema: json("input_schema").$type(),
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
    actionSchema: json("action_schema").$type(),
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
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
});
export const userAgents = pgTable("user_agents", {
    id: text("id").primaryKey(),
    userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    description: text("description"),
    systemPrompt: text("system_prompt"),
    model: text("model").default("gpt-4o"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
});
//# sourceMappingURL=agents.js.map