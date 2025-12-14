// app.js
require("dotenv").config();
const express = require("express");

const sql = require("./src/config/db");

const authRoutes = require("./src/routes/authRoutes");
const adviceRoutes = require("./src/routes/adviceRoutes");
const fieldRoutes = require("./src/routes/fieldRoutes");
const sensorRoutes = require("./src/routes/sensorRoutes");

const app = express();
app.use(express.json());

// routes
app.use("/auth", authRoutes);
app.use("/advice", adviceRoutes);
app.use("/fields", fieldRoutes);
app.use("/sensors", sensorRoutes);

// DB + API health check
app.get("/health", async (req, res) => {
  try {
    const r = await sql`select now() as now`;
    res.json({ ok: true, db: true, now: r[0].now });
  } catch (e) {
    res.status(500).json({ ok: false, db: false, error: e.message });
  }
});

// basic check
app.get("/", (req, res) => res.send("API is running ✅"));

const port = process.env.PORT || 5000;

app.listen(port, async () => {
  console.log(`Server running on http://localhost:${port}`);

  // DB startup check (log only)
  try {
    await sql`select 1 as ok`;
    console.log("DB connected ✅");
  } catch (e) {
    console.error("DB connection failed ❌:", e.message);
  }
});

/// postman bnu anda
//bga anda
