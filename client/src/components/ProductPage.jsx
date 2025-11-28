import React, { useState, useEffect } from 'react';
import './ProductPage.css';

const ProductPage = ({ product, onBack }) => {
  const [isLoading, setIsLoading] = useState(false);
  const [reviews, setReviews] = useState([]);
  
  // REAL STATS FROM SERVER
  const [realStats, setRealStats] = useState({
    average_rating: 0,
    total_reviews: 0,
    breakdown: []
  });

  const [newComment, setNewComment] = useState({ name: '', rating: 5, content: '' });
  const [submitting, setSubmitting] = useState(false);

  // 1. Fetch Reviews List
  const fetchReviews = async () => {
    try {
      const response = await fetch(`http://localhost:4000/api/products/${product.id}/reviews`);
      const data = await response.json();
      if (data.success) setReviews(data.data);
    } catch (err) { console.error(err); }
  };

  // 2. Fetch Aggregated Stats
  const fetchStats = async () => {
    try {
      const response = await fetch(`http://localhost:4000/api/products/${product.id}/aggregate`);
      const data = await response.json();
      if (data.success) {
        setRealStats(data.data);
      }
    } catch (err) { console.error(err); }
  };

  // Initial Load
  useEffect(() => {
    fetchReviews();
    fetchStats(); 
  }, [product.id]);

  // 3. Handle Scraper Fetch Button
  const handleFetch = async () => {
    setIsLoading(true);
    try {
      const response = await fetch(`http://localhost:4000/api/products/${product.id}/fetch`, { method: 'POST' });
      const result = await response.json();
      if (result.success) {
        // Refresh data to show updates instantly
        fetchReviews();
        fetchStats(); 
      }
    } catch (error) {
      console.error(error);
    } finally {
      setIsLoading(false);
    }
  };

  // 4. Handle User Review Submission
  const handleSubmitReview = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    try {
      const response = await fetch(`http://localhost:4000/api/products/${product.id}/reviews`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          reviewer_name: newComment.name,
          rating: parseInt(newComment.rating),
          content: newComment.content
        })
      });
      const result = await response.json();
      if (result.success) {
        setNewComment({ name: '', rating: 5, content: '' }); // Clear form
        // Refresh data
        fetchReviews(); 
        fetchStats();
      } else {
        console.error("Error: " + result.error);
      }
    } catch (error) {
      console.error(error);
    } finally {
      setSubmitting(false);
    }
  };

  // Helper to render star icons
  const renderStars = (count) => {
    const rounded = Math.round(Number(count));
    return '★'.repeat(rounded) + '☆'.repeat(5 - rounded);
  };

  return (
    <div className="product-page-container">
      <div style={{marginBottom: '20px'}}>
        <button onClick={onBack} className="back-btn"><span>←</span> Back</button>
      </div>

      {/* HERO SECTION */}
      <section className="product-hero">
        <img src={product.image} alt={product.name} className="hero-image" />
        <div className="hero-details">
          <div style={{display: 'flex', gap: '10px', marginBottom: '10px'}}>
             <span className="badge">{product.brand}</span>
             <span className="badge category">{product.category}</span>
          </div>
          <h1 className="product-title">{product.name}</h1>
          <p className="product-price">{product.price}</p>
          <p style={{color: '#666', lineHeight: 1.6}}>{product.description}</p>
          
          <div className="rating-overview">
            <span>{renderStars(realStats.average_rating)}</span>
            <span style={{color: '#000', fontWeight: 'bold', marginLeft: '10px'}}>{realStats.average_rating}/5</span>
            <span style={{color: '#888', fontSize: '16px'}}> ({realStats.total_reviews} reviews)</span>
          </div>

          <button className="btn-fetch" onClick={handleFetch} disabled={isLoading}>
            {isLoading ? '⏳ Updating...' : '⚡ Fetch Latest Reviews'}
          </button>
        </div>
      </section>

      {/* ANALYTICS SECTION */}
      <section className="analytics-grid">
        
        {/* WRITE REVIEW FORM */}
        <div className="card review-form-card">
          <h3 className="card-title">✍️ Write a Review</h3>
          <form onSubmit={handleSubmitReview}>
            <div className="form-group">
              <label>Your Name</label>
              <input 
                type="text" required 
                value={newComment.name}
                onChange={e => setNewComment({...newComment, name: e.target.value})}
                placeholder="Your Name"
              />
            </div>
            <div className="form-group">
              <label>Rating</label>
              <select 
                value={newComment.rating}
                onChange={e => setNewComment({...newComment, rating: e.target.value})}
              >
                <option value="5">⭐⭐⭐⭐⭐ (Excellent)</option>
                <option value="4">⭐⭐⭐⭐ (Good)</option>
                <option value="3">⭐⭐⭐ (Average)</option>
                <option value="2">⭐⭐ (Poor)</option>
                <option value="1">⭐ (Bad)</option>
              </select>
            </div>
            <div className="form-group">
              <label>Review</label>
              <textarea 
                required rows="3"
                value={newComment.content}
                onChange={e => setNewComment({...newComment, content: e.target.value})}
                placeholder="Share your thoughts..."
              ></textarea>
            </div>
            <button type="submit" className="btn-submit" disabled={submitting}>
              {submitting ? 'Submitting...' : 'Submit Review'}
            </button>
          </form>
        </div>

        {/* STATS CARD (REAL DATA) */}
        <div className="card">
          <h3 className="card-title">Source Breakdown</h3>
          {realStats.breakdown.length > 0 ? (
            <table className="stats-table">
              <thead>
                <tr style={{textAlign: 'left', color:'#888'}}><th>Source</th><th>Avg Rating</th><th>Count</th></tr>
              </thead>
              <tbody>
                {realStats.breakdown.map((item, index) => (
                  <tr key={index}>
                    <td style={{fontWeight:'bold'}}>{item.source}</td>
                    <td style={{color:'#f5a623'}}>★ {Number(item.avg_rating).toFixed(1)}</td>
                    <td>{item.count}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : (
            <div style={{color:'#888', fontStyle:'italic', padding:'20px', textAlign:'center'}}>
              No data available yet. Click "Fetch Latest Reviews" to get started.
            </div>
          )}
        </div>
      </section>

      {/* REVIEWS LIST */}
      <section className="reviews-container">
        <h3 className="section-title">Customer Reviews ({reviews.length})</h3>
        <div className="reviews-list">
          {reviews.map((review) => (
            <div key={review.id} className="review-item">
              <div className="review-header">
                <div className="review-user">
                  <div className="avatar">{review.reviewer_name ? review.reviewer_name.charAt(0).toUpperCase() : 'U'}</div>
                  <div>
                    <span className="author-name">{review.reviewer_name}</span>
                    <div className="review-meta">
                      <span className="source-badge">via {review.source}</span>
                      <span className="date">• {review.review_date ? new Date(review.review_date).toLocaleDateString() : ''}</span>
                    </div>
                  </div>
                </div>
                <div className="review-rating">{renderStars(review.rating)}</div>
              </div>
              <p className="review-text">{review.content}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
};

export default ProductPage;