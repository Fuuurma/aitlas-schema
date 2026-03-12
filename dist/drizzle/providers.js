// AI Providers & Models
import { pgTable, text, timestamp, boolean, integer, decimal, json, } from "drizzle-orm/pg-core";
export const providers = pgTable("providers", {
    id: text("id").primaryKey(),
    name: text("name").notNull(),
    displayName: text("display_name"),
    description: text("description"),
    baseUrl: text("base_url"),
    apiKeyEnv: text("api_key_env"),
    rateLimitRpm: integer("rate_limit_rpm").default(60),
    rateLimitTpm: integer("rate_limit_tpm").default(90000),
    enabled: boolean("enabled").default(true),
    config: json("config").$type().default({}),
    createdAt: timestamp("created_at").notNull().defaultNow(),
    updatedAt: timestamp("updated_at").notNull().defaultNow(),
});
export const models = pgTable("models", {
    id: text("id").primaryKey(),
    providerId: text("provider_id").notNull().references(() => providers.id, { onDelete: "cascade" }),
    name: text("name").notNull(),
    displayName: text("display_name"),
    contextWindow: integer("context_window").default(4096),
    maxOutputTokens: integer("max_output_tokens").default(4096),
    inputCostPer1k: decimal("input_cost_per_1k", { precision: 10, scale: 6 }).default("0"),
    outputCostPer1k: decimal("output_cost_per_1k", { precision: 10, scale: 6 }).default("0"),
    supportsVision: boolean("supports_vision").default(false),
    supportsTools: boolean("supports_tools").default(true),
    supportsStreaming: boolean("supports_streaming").default(true),
    capabilities: json("capabilities").$type().default([]),
    enabled: boolean("enabled").default(true),
    createdAt: timestamp("created_at").notNull().defaultNow(),
});
//# sourceMappingURL=providers.js.map