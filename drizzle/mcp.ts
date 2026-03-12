// MCP (Model Context Protocol)
import {
  pgTable,
  text,
  timestamp,
  boolean,
  bigint,
  json,
} from "drizzle-orm/pg-core";

export const mcpServers = pgTable("mcp_servers", {
  id: text("id").primaryKey(),
  name: text("name").notNull().unique(),
  displayName: text("display_name"),
  description: text("description"),
  transport: text("transport").notNull(),
  command: text("command"),
  args: json("args").$type<string[]>().default([]),
  env: json("env").$type<Record<string, string>>().default({}),
  url: text("url"),
  enabled: boolean("enabled").default(true),
  autoStart: boolean("auto_start").default(false),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export const mcpTools = pgTable("mcp_tools", {
  id: text("id").primaryKey(),
  serverId: text("server_id").notNull().references(() => mcpServers.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  description: text("description"),
  inputSchema: json("input_schema").$type<Record<string, unknown>>().notNull(),
  outputSchema: json("output_schema").$type<Record<string, unknown>>(),
  annotations: json("annotations").$type<Record<string, unknown>>().default({}),
  enabled: boolean("enabled").default(true),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export const mcpResources = pgTable("mcp_resources", {
  id: text("id").primaryKey(),
  serverId: text("server_id").notNull().references(() => mcpServers.id, { onDelete: "cascade" }),
  uri: text("uri").notNull(),
  name: text("name").notNull(),
  description: text("description"),
  mimeType: text("mime_type"),
  sizeBytes: bigint("size_bytes", { mode: "number" }),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type McpServer = typeof mcpServers.$inferSelect;
export type NewMcpServer = typeof mcpServers.$inferInsert;
export type McpTool = typeof mcpTools.$inferSelect;
export type McpResource = typeof mcpResources.$inferSelect;