// Prompts & Templates
import {
  pgTable,
  text,
  timestamp,
  integer,
  json,
} from "drizzle-orm/pg-core";

export const systemPrompts = pgTable("system_prompts", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  description: text("description"),
  content: text("content").notNull(),
  variables: json("variables").$type<Array<{ name: string; type: string; default?: unknown }>>().default([]),
  category: text("category"),
  tags: json("tags").$type<string[]>().default([]),
  version: integer("version").default(1),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const promptTemplates = pgTable("prompt_templates", {
  id: text("id").primaryKey(),
  name: text("name").notNull().unique(),
  description: text("description"),
  template: text("template").notNull(),
  variables: json("variables").$type<Array<{ name: string; type: string; required?: boolean; default?: unknown }>>().default([]),
  category: text("category"),
  tags: json("tags").$type<string[]>().default([]),
  version: integer("version").default(1),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export type SystemPrompt = typeof systemPrompts.$inferSelect;
export type NewSystemPrompt = typeof systemPrompts.$inferInsert;
export type PromptTemplate = typeof promptTemplates.$inferSelect;
export type NewPromptTemplate = typeof promptTemplates.$inferInsert;