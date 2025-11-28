# LLM Usage Documentation

## Project Info
- **Team Number:** 2
- **Team Members:**
  1. Nguyễn Quang
  2. Vũ Bá Bình
  3. Nguyễn Quốc An
  4. Nguyễn Thuận An
  5. Thảo Nguyên
- **Date:** 2025-10-25

---

## Part 1: Frontend Development (React)

### 1. Product Grid & UI
> **Context:** Building the main product catalog.
> **Prompt:** "Create a `ProductList` React component using CSS Grid. It must display 27 camera products with an image, title, price, and rating. Implement client-side filtering for **Brand**, **Category**, and **Rating**. Add pagination (9 items/page) that automatically resets to Page 1 when filters change. Ensure the design is responsive."

**🔴 Verification & Correction:**
* **Challenge:** The AI used Unsplash URLs which frequently returned 404 errors or irrelevant images.
* **Fix:** We prompted the AI to refactor the data structure to use **local images** (`/public/p1.jpg`...) instead of external links to ensure reliability.

### 2. Detail Page & Interactivity
> **Context:** Building the product detail view.
> **Prompt:** "Create a `ProductPage` component that fetches real-time data from `localhost:4000`. Implement a 'Write Review' form and a 'Fetch Latest Reviews' button. When data is submitted or fetched, the UI must update immediately without reloading the page. Also, display a Rating Histogram and Source Breakdown table."

**🔴 Verification & Correction:**
* **Challenge:** The average rating displayed floating-point errors (e.g., `4.8000001`).
* **Fix:** We manually added `.toFixed(1)` to the rendering logic to format ratings cleanly.

---

## Part 2: Backend Development (Node.js)

### 3. API & Scraper Logic
> **Context:** Setting up the server to handle data.
> **Prompt:** "Create a Node.js Express server. Implement a `mockScraper.js` service that simulates fetching 5-10 reviews with a 1.5s delay. Create a route `POST /api/products/:id/fetch` that calls this scraper and inserts reviews into MySQL using **`INSERT IGNORE`** to skip duplicates. Return the count of actually inserted rows."

**🔴 Verification & Correction:**
* **Challenge:** The server process exited immediately upon startup (`nodemon clean exit`).
* **Fix:** We identified that the AI omitted the `app.listen()` command. We added it to keep the server running.

### 4. Data Handling & Persistence
> **Context:** Managing user submissions.
> **Prompt:** "Create a `POST /reviews` endpoint to handle user-submitted reviews. Validate the input (Name, Rating, Content) and insert it into the `reviews` table. Immediately after insertion, update the `reviews_count` in the `products` table to keep data synchronized."

---

## Part 3: Database Integration (MySQL)

### 5. Schema Design & Data Seeding
> **Context:** Creating the database structure.
> **Prompt:** "Act as a DBA. Write a MySQL script `schema.sql`. Create tables `products` and `reviews` with a Foreign Key. Add a **UNIQUE constraint** to `reviews` on columns `(product_id, source, reviewer_name, content)` to prevent duplicates. Write a SQL script (using CTE) to seed 27 products and automatically generate 50-100 random reviews for each."

**🔴 Verification & Correction:**
* **Challenge:** The AI initially suggested using Stored Procedures, which caused Syntax Errors in MySQL Workbench.
* **Fix:** We prompted the AI to rewrite the seed script using standard SQL `WITH RECURSIVE` (CTE) and explicitly disabled Safe Update Mode (`SET SQL_SAFE_UPDATES = 0;`) to allow bulk updates.

---

## Critical Reflection

1.  **Context is Crucial:** LLMs often "forget" previous instructions (e.g., variable names like `reviews_count`). We learned to provide full context (table schemas, file structures) in every prompt to maintain consistency.
2.  **Code Verification:** AI-generated SQL often misses environment-specific constraints (like Safe Update Mode). We had to manually test and debug every script in MySQL Workbench before integrating.
3.  **Architectural Decisions:** The AI suggested keeping state in child components, which caused navigation bugs. We had to manually intervene and "lift state up" to `App.jsx` to preserve user context.