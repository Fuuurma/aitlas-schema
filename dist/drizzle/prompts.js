// Prompts & Templates
import { pgTable, text, timestamp, integer, json, } from "drizzle-orm/pg-core";
export const systemPrompts = pgTable("system_prompts", {
    id: text("id").primaryKey(),
    name: text("name").notNull(),
    description: text("description"),
    content: text("content").notNull(),
    variables: json("variables").$type().default([]),
    category: text("category"),
    tags: json("tags").$type().default([]),
    version: integer("version").default(1),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
});
export const promptTemplates = pgTable("prompt_templates", {
    id: text("id").primaryKey(),
    name: text("name").notNull().unique(),
    description: text("description"),
    template: text("template").notNull(),
    variables: json("variables").$type().default([]),
    category: text("category"),
    tags: json("tags").$type().default([]),
    version: integer("version").default(1),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
});
//# sourceMappingURL=prompts.js.map