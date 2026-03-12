// Webhooks
import {
  pgTable,
  text,
  timestamp,
  boolean,
  integer,
  json,
} from "drizzle-orm/pg-core";
import { users } from "./users";

export const webhooks = pgTable("webhooks", {
  id: text("id").primaryKey(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  url: text("url").notNull(),
  secret: text("secret"),
  events: json("events").$type<string[]>().notNull().default([]),
  enabled: boolean("enabled").default(true),
  lastTriggeredAt: timestamp("last_triggered_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export const webhookDeliveries = pgTable("webhook_deliveries", {
  id: text("id").primaryKey(),
  webhookId: text("webhook_id").notNull().references(() => webhooks.id, { onDelete: "cascade" }),
  eventType: text("event_type").notNull(),
  payload: json("payload").$type<Record<string, unknown>>().notNull(),
  responseStatus: integer("response_status"),
  responseBody: text("response_body"),
  attempts: integer("attempts").default(0),
  deliveredAt: timestamp("delivered_at"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type Webhook = typeof webhooks.$inferSelect;
export type NewWebhook = typeof webhooks.$inferInsert;
export type WebhookDelivery = typeof webhookDeliveries.$inferSelect;