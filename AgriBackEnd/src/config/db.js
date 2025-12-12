// src/config/db.js
const postgres = require("postgres");

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error("DATABASE_URL is missing in .env");
}

const sql = postgres(connectionString, {
  ssl: "require",
  max: 10,
  idle_timeout: 20,
  connect_timeout: 30,
});

module.exports = sql;
