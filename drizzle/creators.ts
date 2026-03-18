import {
  pgTable,
  text,
  timestamp,
  boolean,
  uuid,
  decimal,
  date,
} from "drizzle-orm/pg-core";
import { users } from "./users";
import { agents } from "./agents";

export const creators = pgTable("creators", {
  id: uuid("id").primaryKey().defaultRandom(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }).unique(),
  username: text("username").notNull().unique(),
  displayName: text("display_name").notNull(),
  bio: text("bio"),
  avatarUrl: text("avatar_url"),
  websiteUrl: text("website_url"),
  tier: text("tier").default("community"),
  isVerified: boolean("is_verified").default(false),
  stripeAccountId: text("stripe_account_id"),
  totalEarnings: decimal("total_earnings", { precision: 20, scale: 2 }).default("0"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const creatorEarnings = pgTable("creator_earnings", {
  id: uuid("id").primaryKey().defaultRandom(),
  creatorId: uuid("creator_id").notNull().references(() => creators.id, { onDelete: "cascade" }),
  agentId: uuid("agent_id").references(() => agents.id, { onDelete: "set null" }),
  payoutId: uuid("payout_id").references(() => creatorPayouts.id, { onDelete: "set null" }),
  source: text("source").notNull(),
  grossAmount: decimal("gross_amount", { precision: 20, scale: 2 }).notNull(),
  platformFee: decimal("platform_fee", { precision: 20, scale: 2 }).notNull(),
  netAmount: decimal("net_amount", { precision: 20, scale: 2 }).notNull(),
  stripeEventId: text("stripe_event_id"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export const creatorPayouts = pgTable("creator_payouts", {
  id: uuid("id").primaryKey().defaultRandom(),
  creatorId: uuid("creator_id").notNull().references(() => creators.id, { onDelete: "cascade" }),
  amount: decimal("amount", { precision: 20, scale: 2 }).notNull(),
  stripePayoutId: text("stripe_payout_id"),
  status: text("status").default("pending"),
  periodStart: date("period_start").notNull(),
  periodEnd: date("period_end").notNull(),
  paidAt: timestamp("paid_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type Creator = typeof creators.$inferSelect;
export type NewCreator = typeof creators.$inferInsert;
export type CreatorEarning = typeof creatorEarnings.$inferSelect;
export type NewCreatorEarning = typeof creatorEarnings.$inferInsert;
export type CreatorPayout = typeof creatorPayouts.$inferSelect;
export type NewCreatorPayout = typeof creatorPayouts.$inferInsert;