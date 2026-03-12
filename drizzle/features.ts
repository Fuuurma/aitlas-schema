// Feature Flags
import {
  pgTable,
  text,
  timestamp,
  boolean,
  integer,
  json,
} from "drizzle-orm/pg-core";
import { users } from "./users";

export const featureFlags = pgTable("feature_flags", {
  id: text("id").primaryKey(),
  name: text("name").notNull().unique(),
  description: text("description"),
  enabled: boolean("enabled").default(false),
  rolloutPercentage: integer("rollout_percentage").default(0),
  conditions: json("conditions").$type<Record<string, unknown>>().default({}),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const userFeatureFlags = pgTable("user_feature_flags", {
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  flagId: text("flag_id").notNull().references(() => featureFlags.id, { onDelete: "cascade" }),
  enabled: boolean("enabled").notNull(),
  createdAt: timestamp("created_at").notNull().defaultNow(),
}, (table) => ({
  pk: { columns: [table.userId, table.flagId], name: "user_feature_flags_pkey" },
}));

export type FeatureFlag = typeof featureFlags.$inferSelect;
export type NewFeatureFlag = typeof featureFlags.$inferInsert;
export type UserFeatureFlag = typeof userFeatureFlags.$inferSelect;