// Workflows
import {
  pgTable,
  text,
  timestamp,
  boolean,
  json,
} from "drizzle-orm/pg-core";
import { users } from "./users";

export const workflows = pgTable("workflows", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  description: text("description"),
  definition: json("definition").$type<Record<string, unknown>>().notNull(),
  triggers: json("triggers").$type<Array<Record<string, unknown>>>().default([]),
  inputSchema: json("input_schema").$type<Record<string, unknown>>().default({}),
  outputSchema: json("output_schema").$type<Record<string, unknown>>().default({}),
  enabled: boolean("enabled").default(true),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const workflowExecutions = pgTable("workflow_executions", {
  id: text("id").primaryKey(),
  workflowId: text("workflow_id").notNull().references(() => workflows.id, { onDelete: "cascade" }),
  userId: text("user_id").references(() => users.id, { onDelete: "set null" }),
  status: text("status").notNull().default("pending"),
  input: json("input").$type<Record<string, unknown>>().notNull(),
  output: json("output").$type<Record<string, unknown>>(),
  error: text("error"),
  currentStep: text("current_step"),
  context: json("context").$type<Record<string, unknown>>().default({}),
  startedAt: timestamp("started_at"),
  completedAt: timestamp("completed_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type Workflow = typeof workflows.$inferSelect;
export type NewWorkflow = typeof workflows.$inferInsert;
export type WorkflowExecution = typeof workflowExecutions.$inferSelect;