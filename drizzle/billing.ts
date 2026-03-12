// Billing
import {
  pgTable,
  text,
  timestamp,
  boolean,
  integer,
  decimal,
  json,
} from "drizzle-orm/pg-core";
import { users } from "./users";
import { models } from "./providers";

export const plans = pgTable("plans", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  displayName: text("display_name"),
  description: text("description"),
  priceMonthly: decimal("price_monthly", { precision: 10, scale: 2 }).default("0"),
  priceYearly: decimal("price_yearly", { precision: 10, scale: 2 }).default("0"),
  creditsIncluded: integer("credits_included").default(0),
  creditsPerMonth: integer("credits_per_month").default(0),
  features: json("features").$type<Record<string, unknown>>().default({}),
  limits: json("limits").$type<Record<string, unknown>>().default({}),
  stripeProductId: text("stripe_product_id"),
  stripePriceMonthlyId: text("stripe_price_monthly_id"),
  stripePriceYearlyId: text("stripe_price_yearly_id"),
  isActive: boolean("is_active").default(true),
  isDefault: boolean("is_default").default(false),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const subscriptions = pgTable("subscriptions", {
  id: text("id").primaryKey(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  planId: text("plan_id").notNull().references(() => plans.id, { onDelete: "restrict" }),
  status: text("status").notNull().default("active"),
  stripeSubscriptionId: text("stripe_subscription_id"),
  stripeCustomerId: text("stripe_customer_id"),
  currentPeriodStart: timestamp("current_period_start"),
  currentPeriodEnd: timestamp("current_period_end"),
  cancelAtPeriodEnd: boolean("cancel_at_period_end").default(false),
  cancelledAt: timestamp("cancelled_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const creditRates = pgTable("credit_rates", {
  id: text("id").primaryKey(),
  modelId: text("model_id").notNull().references(() => models.id, { onDelete: "cascade" }),
  inputCostPerToken: decimal("input_cost_per_token", { precision: 10, scale: 8 }).notNull(),
  outputCostPerToken: decimal("output_cost_per_token", { precision: 10, scale: 8 }).notNull(),
  effectiveFrom: timestamp("effective_from").notNull().defaultNow(),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type Plan = typeof plans.$inferSelect;
export type NewPlan = typeof plans.$inferInsert;
export type Subscription = typeof subscriptions.$inferSelect;
export type CreditRate = typeof creditRates.$inferSelect;