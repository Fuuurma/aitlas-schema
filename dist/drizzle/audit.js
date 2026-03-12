// Audit Logs
import { pgTable, text, timestamp, json, } from "drizzle-orm/pg-core";
import { users } from "./users";
export const auditLogs = pgTable("audit_logs", {
    id: text("id").primaryKey(),
    userId: text("user_id").references(() => users.id, { onDelete: "set null" }),
    action: text("action").notNull(),
    resourceType: text("resource_type"),
    resourceId: text("resource_id"),
    oldValues: json("old_values").$type(),
    newValues: json("new_values").$type(),
    ipAddress: text("ip_address"),
    userAgent: text("user_agent"),
    createdAt: timestamp("created_at").notNull().defaultNow(),
});
//# sourceMappingURL=audit.js.map