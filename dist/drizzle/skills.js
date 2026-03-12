// Skills
import { pgTable, text, timestamp, boolean, integer, uuid, json, } from "drizzle-orm/pg-core";
import { tasks } from "./tasks";
export const skills = pgTable("skills", {
    id: text("id").primaryKey(),
    name: text("name").notNull().unique(),
    displayName: text("display_name"),
    description: text("description"),
    category: text("category"),
    tags: json("tags").$type().default([]),
    requiredTools: json("required_tools").$type().default([]),
    optionalTools: json("optional_tools").$type().default([]),
    configSchema: json("config_schema").$type().default({}),
    defaultConfig: json("default_config").$type().default({}),
    version: text("version").default("1.0.0"),
    enabled: boolean("enabled").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
});
export const skillExecutions = pgTable("skill_executions", {
    id: text("id").primaryKey(),
    skillId: text("skill_id").notNull().references(() => skills.id, { onDelete: "cascade" }),
    taskId: uuid("task_id").references(() => tasks.id, { onDelete: "set null" }),
    input: json("input").$type().notNull(),
    output: json("output").$type(),
    error: text("error"),
    durationMs: integer("duration_ms"),
    success: boolean("success"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
});
//# sourceMappingURL=skills.js.map