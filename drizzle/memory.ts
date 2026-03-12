// Memory
import {
  pgTable,
  text,
  timestamp,
  json,
} from "drizzle-orm/pg-core";
import { users } from "./users";

export const memoryEpisodes = pgTable("memory_episodes", {
  id: text("id").primaryKey(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  taskId: text("task_id"),
  content: text("content").notNull(),
  metadata: json("metadata").$type<Record<string, unknown>>().default({}),
  importance: text("importance").default("medium"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export const memoryKnowledge = pgTable("memory_knowledge", {
  id: text("id").primaryKey(),
  userId: text("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  key: text("key").notNull(),
  value: text("value").notNull(),
  category: text("category"),
  confidence: text("confidence").default("medium"),
  source: text("source"),
  createdAt: timestamp("created_at").notNull().defaultNow(),
  updatedAt: timestamp("updated_at").notNull().defaultNow(),
});

export const memoryEmbeddings = pgTable("memory_embeddings", {
  id: text("id").primaryKey(),
  memoryType: text("memory_type").notNull(),
  memoryId: text("memory_id").notNull(),
  content: text("content").notNull(),
  embedding: text("embedding"), // Stored as JSON array, use pgvector in production
  metadata: json("metadata").$type<Record<string, unknown>>().default({}),
  createdAt: timestamp("created_at").notNull().defaultNow(),
});

export type MemoryEpisode = typeof memoryEpisodes.$inferSelect;
export type MemoryKnowledge = typeof memoryKnowledge.$inferSelect;
export type MemoryEmbedding = typeof memoryEmbeddings.$inferSelect;