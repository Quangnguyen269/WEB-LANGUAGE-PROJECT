const express = require('express');
const router = express.Router();
const { pool } = require('../config/database');
const { fetchReviewsFromSources } = require('../services/mockScraper');

// 1. GET ALL PRODUCTS (Fetch list + real review count)
// Uses LEFT JOIN to accurately count reviews from the 'reviews' table
router.get('/', async (req, res) => {
  try {
    const query = `
      SELECT p.*, COUNT(r.id) as reviews_count 
      FROM products p 
      LEFT JOIN reviews r ON p.id = r.product_id 
      GROUP BY p.id
    `;
    const [rows] = await pool.query(query);
    res.json({ success: true, data: rows, count: rows.length });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// 2. GET PRODUCT BY ID (Fetch details + real review count)
router.get('/:id', async (req, res) => {
  try {
    const query = `
      SELECT p.*, COUNT(r.id) as reviews_count 
      FROM products p 
      LEFT JOIN reviews r ON p.id = r.product_id 
      WHERE p.id = ?
      GROUP BY p.id
    `;
    const [rows] = await pool.query(query, [req.params.id]);
    if (rows.length === 0) return res.status(404).json({ success: false, error: 'Product not found' });
    res.json({ success: true, data: rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// 3. FETCH REVIEWS (Scraper - Auto update reviews)
router.post('/:id/fetch', async (req, res) => {
  try {
    const productId = req.params.id;
    const newReviews = await fetchReviewsFromSources(productId);
    
    let addedCount = 0;
    for (const review of newReviews) {
      const [result] = await pool.query(
        `INSERT IGNORE INTO reviews 
        (product_id, source, reviewer_name, rating, content, review_date) 
        VALUES (?, ?, ?, ?, ?, ?)`,
        [productId, review.source, review.reviewer_name, review.rating, review.content, review.review_date]
      );
      if (result.affectedRows > 0) addedCount++;
    }

    res.json({ success: true, message: `Fetched ${newReviews.length} reviews. Saved ${addedCount} new ones.`, data: { added: addedCount } });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// 4. POST USER REVIEW (Save user review to database)
router.post('/:id/reviews', async (req, res) => {
  try {
    const productId = req.params.id;
    const { reviewer_name, rating, content } = req.body;

    // Validate
    if (!reviewer_name || !rating || !content) {
      return res.status(400).json({ success: false, error: 'Please fill all fields' });
    }

    // Insert into Database
    await pool.query(
      'INSERT INTO reviews (product_id, source, reviewer_name, rating, content, review_date) VALUES (?, ?, ?, ?, ?, NOW())',
      [productId, 'Website User', reviewer_name, rating, content]
    );

    res.json({ success: true, message: 'Review saved successfully!' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: err.message });
  }
});

// 5. GET REVIEWS (Fetch list of reviews for display)
router.get('/:id/reviews', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM reviews WHERE product_id = ? ORDER BY id DESC', [req.params.id]);
    res.json({ success: true, data: rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

// 6. AGGREGATE STATS
router.get('/:id/aggregate', async (req, res) => {
  try {
    const [stats] = await pool.query(
      'SELECT AVG(rating) as average_rating, COUNT(*) as total_reviews FROM reviews WHERE product_id = ?', 
      [req.params.id]
    );
    const [breakdown] = await pool.query(
      'SELECT source, AVG(rating) as avg_rating, COUNT(*) as count FROM reviews WHERE product_id = ? GROUP BY source',
      [req.params.id]
    );
    
    res.json({
      success: true,
      data: {
        average_rating: Number(stats[0].average_rating).toFixed(1) || 0,
        total_reviews: stats[0].total_reviews,
        breakdown: breakdown
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

module.exports = router;