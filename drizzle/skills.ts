// Skills
import {
  pgTable,
  text,
  timestamp,
  boolean,
  integer,
  uuid,
  json,
} from "drizzle-orm/pg-core";
import { tasks } from "./tasks";

export const skills = pgTable("skills", {
  id: text("id").primaryKey(),
  name: text("name").notNull().unique(),
  displayName: text("display_name"),
  description: text("description"),
  category: text("category"),
  tags: json("tags").$type<string[]>().default([]),
  requiredTools: json("required_tools").$type<string[]>().default([]),
  optionalTools: json("optional_tools").$type<string[]>().default([]),
  configSchema: json("config_schema").$type<Record<string, unknown>>().default({}),
  defaultConfig: json("default_config").$type<Record<string, unknown>>().default({}),
  version: text("version").default("1.0.0"),
  enabled: boolean("enabled").default(true),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const skillExecutions = pgTable("skill_executions", {
  id: text("id").primaryKey(),
  skillId: text("skill_id").notNull().references(() => skills.id, { onDelete: "cascade" }),
  taskId: uuid("task_id").references(() => tasks.id, { onDelete: "set null" }),
  input: json("input").$type<Record<string, unknown>>().notNull(),
  output: json("output").$type<Record<string, unknown>>(),
  error: text("error"),
  durationMs: integer("duration_ms"),
  success: boolean(),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type Skill = typeof skills.$inferSelect;
export type NewSkill = typeof skills.$inferInsert;
export type SkillExecution = typeof skillExecutions.$inferSelect;