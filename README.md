### 1. Product Catalog & Navigation
* **Product Listing:** The homepage displays a responsive grid of 27 high-end camera products. Each product card shows the image, name, price, brand, and the current number of reviews.
* **Pagination:** To ensure optimal performance and a clean interface, the list is paginated (9 items per page). Users can navigate between pages using "Next" and "Previous" buttons.
* **Filtering:** Users can filter the product list based on three criteria:
    * **Category:** Filter by Camera, Drone, or Action Cam.
    * **Brand:** Filter by specific manufacturers (e.g., Canon, Sony).
    * **Rating:** Filter products by star rating (e.g., showing only products with 5 stars).
    * *Logic:* When a filter is applied, the pagination automatically resets to Page 1.

### 2. Review Aggregation (Scraping Simulation)
This is the core feature of the project.
* **On-Demand Fetching:** On the Product Detail page, there is a **"Fetch Latest Reviews"** button. Clicking this triggers a backend process that simulates scraping data from external e-commerce sites (Amazon, BestBuy, Walmart) with a realistic network delay.
* **Duplicate Prevention:** The system checks if a review already exists in the database (based on Product ID + Source + User + Content). If it exists, the database rejects it to prevent duplicates. The user receives a report on exactly how many *new* reviews were saved.

### 3. User Reviews
* **Submission Form:** Users can write their own reviews using a form on the product detail page. They provide their name, a star rating (1-5), and a comment.
* **Instant Update:** Once submitted, the review is saved to the MySQL database, and the review list updates immediately without reloading the page.

### 4. Statistics & Analytics
* **Aggregated Data:** The application calculates statistics in real-time based on the data in the MySQL database:
    * **Average Rating:** The overall star rating of the product.
    * **Source Breakdown:** A table showing the average rating and review count for each source (e.g., "Amazon: 4.8 stars, 120 reviews").
    * **Rating Histogram:** A visual bar chart showing the distribution of star ratings.

### 5. Advanced Features (Bonus)
* **Product Comparison:** Users can select up to 3 products to compare side-by-side in a floating comparison bar.
* **Technical Specifications:** Detailed product specifications (Sensor, Video, Weight, etc.) are stored as JSON in the database and displayed in a clean table on the product page.

---

## 🛠️ Project Setup

### Prerequisites
* Node.js installed.
* MySQL Server installed and running.

### Step 1: Database Configuration
1.  Open **MySQL Workbench**.
2.  Run the provided SQL script: `database/schema.sql`.
    * *This script resets the database, creates tables, and seeds initial product data with random reviews.*

### Step 2: Backend Setup (Server)
1.  Navigate to the `server` folder: `cd server`
2.  Install dependencies: `npm install`
3.  Create a `.env` file in the `server` folder:
    ```env
    DB_HOST=127.0.0.1
    DB_USER=root
    DB_PASSWORD=YOUR_PASSWORD
    DB_NAME=review_db
    PORT=4000
    ```
4.  Start the server: `npm run dev`

### Step 3: Frontend Setup (Client)
1.  Navigate to the `client` folder: `cd client`
2.  Install dependencies: `npm install`
3.  Start the app: `npm run dev`
4.  Access via browser: `http://localhost:5173`

---

## 📂 Project Structure