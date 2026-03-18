import {
  pgTable,
  text,
  timestamp,
  boolean,
  uuid,
  integer,
  json,
  unique,
  check,
} from "drizzle-orm/pg-core";
import { agents } from "./agents";
import { users } from "./users";
import { sql } from "drizzle-orm";

export const agentVersions = pgTable("agent_versions", {
  id: uuid("id").primaryKey().defaultRandom(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  version: text("version").notNull(),
  spec: json("spec").$type<Record<string, unknown>>().notNull(),
  changelog: text("changelog"),
  isPublished: boolean("is_published").default(false),
  publishedAt: timestamp("published_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
}, (table) => ({
  versionUnique: unique().on(table.agentId, table.version),
}));

export const agentReviews = pgTable("agent_reviews", {
  id: uuid("id").primaryKey().defaultRandom(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  userId: text("user_id").notNull(),
  rating: integer("rating").notNull(),
  body: text("body"),
  runId: text("run_id"),
  isVerifiedRun: boolean("is_verified_run").default(false),
  helpfulCount: integer("helpful_count").default(0),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
}, (table) => ({
  userReviewUnique: unique().on(table.agentId, table.userId),
  ratingCheck: check("rating_check", sql`${table.rating} BETWEEN 1 AND 5`),
}));

export const agentSubscriptions = pgTable("agent_subscriptions", {
  id: uuid("id").primaryKey().defaultRandom(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  userId: text("user_id").notNull(),
  stripeSubId: text("stripe_sub_id").unique(),
  status: text("status").default("active"),
  currentPeriodStart: timestamp("current_period_start"),
  currentPeriodEnd: timestamp("current_period_end"),
  priceCents: integer("price_cents").notNull(),
  cancelledAt: timestamp("cancelled_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const agentRunEvents = pgTable("agent_run_events", {
  id: uuid("id").primaryKey().defaultRandom(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  taskId: text("task_id").notNull(),
  userId: text("user_id").notNull(),
  version: text("version").notNull(),
  status: text("status").notNull(),
  creditsUsed: integer("credits_used"),
  durationMs: integer("duration_ms"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export const curationReviews = pgTable("curation_reviews", {
  id: uuid("id").primaryKey().defaultRandom(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  versionId: uuid("version_id").references(() => agentVersions.id, { onDelete: "set null" }),
  reviewerId: text("reviewer_id"),
  status: text("status").default("pending").notNull(),
  tier: text("tier").default("automated"),
  automatedChecks: json("automated_checks").$type<Record<string, unknown>>(),
  notes: text("notes"),
  rejectionReason: text("rejection_reason"),
  resolvedAt: timestamp("resolved_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const hiredAgents = pgTable("hired_agents", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: text("user_id").notNull(),
  agentId: uuid("agent_id").notNull().references(() => agents.id, { onDelete: "cascade" }),
  status: text("status").default("active"),
  hiredAt: timestamp("hired_at").notNull().defaultNow(),
  expiresAt: timestamp("expires_at"),
  totalRuns: integer("total_runs").default(0),
  lastRunAt: timestamp("last_run_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
}, (table) => ({
  userHireUnique: unique().on(table.userId, table.agentId),
}));

export type AgentVersion = typeof agentVersions.$inferSelect;
export type NewAgentVersion = typeof agentVersions.$inferInsert;
export type AgentReview = typeof agentReviews.$inferSelect;
export type NewAgentReview = typeof agentReviews.$inferInsert;
export type AgentSubscription = typeof agentSubscriptions.$inferSelect;
export type NewAgentSubscription = typeof agentSubscriptions.$inferInsert;
export type AgentRunEvent = typeof agentRunEvents.$inferSelect;
export type NewAgentRunEvent = typeof agentRunEvents.$inferInsert;
export type CurationReview = typeof curationReviews.$inferSelect;
export type NewCurationReview = typeof curationReviews.$inferInsert;
export type HiredAgent = typeof hiredAgents.$inferSelect;
export type NewHiredAgent = typeof hiredAgents.$inferInsert;