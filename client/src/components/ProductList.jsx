import React from 'react';
import './ProductList.css';

const ProductList = ({ 
  products, 
  onProductSelect, 
  currentPage, 
  setCurrentPage, 
  filters, 
  setFilters,
  compareList,
  toggleCompare
}) => {
  const productsPerPage = 9;

  const filteredProducts = products.filter(product => {
    const matchCategory = filters.category === 'All' || product.category === filters.category;
    const matchBrand = filters.brand === 'All' || product.brand === filters.brand;
    const productStar = Math.round(product.rating).toString();
    const matchRating = filters.rating === 'All' || productStar === filters.rating;
    return matchCategory && matchBrand && matchRating;
  });

  const indexOfLastProduct = currentPage * productsPerPage;
  const indexOfFirstProduct = indexOfLastProduct - productsPerPage;
  const currentProducts = filteredProducts.slice(indexOfFirstProduct, indexOfLastProduct);
  const totalPages = Math.ceil(filteredProducts.length / productsPerPage);

  const handleFilterChange = (key, value) => {
    setFilters(prev => ({ ...prev, [key]: value }));
    setCurrentPage(1); 
  };

  const uniqueCategories = ['All', ...new Set(products.map(p => p.category))];
  const uniqueBrands = ['All', ...new Set(products.map(p => p.brand))];

  return (
    <div className="catalog-container">
      <div className="catalog-header">
        <h1 className="catalog-title">Products ({filteredProducts.length})</h1>
        
        <div className="filter-bar">
          <div className="filter-group">
            <label>Category:</label>
            <select value={filters.category} onChange={(e) => handleFilterChange('category', e.target.value)}>
              {uniqueCategories.map(cat => <option key={cat} value={cat}>{cat}</option>)}
            </select>
          </div>
          <div className="filter-group">
            <label>Brand:</label>
            <select value={filters.brand} onChange={(e) => handleFilterChange('brand', e.target.value)}>
              {uniqueBrands.map(brand => <option key={brand} value={brand}>{brand}</option>)}
            </select>
          </div>
          <div className="filter-group">
            <label>Rating:</label>
            <select value={filters.rating} onChange={(e) => handleFilterChange('rating', e.target.value)}>
              <option value="All">All Ratings</option>
              <option value="5">⭐⭐⭐⭐⭐ (5 Stars)</option>
              <option value="4">⭐⭐⭐⭐ (4 Stars)</option>
              <option value="3">⭐⭐⭐ (3 Stars)</option>
            </select>
          </div>
        </div>
      </div>
      
      <div className="product-grid">
        {currentProducts.length > 0 ? (
          currentProducts.map((product) => (
            <div key={product.id} className="product-card">
              <div className="image-container" onClick={() => onProductSelect(product)}>
                <img src={product.image} alt={product.name} className="card-image" />
              </div>
              
              <h3 className="card-title" onClick={() => onProductSelect(product)}>{product.name}</h3>
              <p className="card-price">{product.price}</p>
              
              <div className="card-tags">
                <span className="tag brand">{product.brand}</span>
                <span className="tag category">{product.category}</span>
              </div>

              <div className="card-rating">
                {'★'.repeat(Math.round(product.rating))} 
               <span style={{color: '#888', fontSize: '13px'}}> ({product.reviews_count || 0} reviews)</span>
              </div>

              <div style={{marginBottom: '15px', display:'flex', alignItems:'center', gap:'8px', fontSize:'14px', color:'#555', cursor:'pointer'}} 
                   onClick={(e) => { e.stopPropagation(); toggleCompare(product); }}>
                <input 
                  type="checkbox" 
                  style={{cursor:'pointer', width:'16px', height:'16px'}}
                  checked={compareList && compareList.some(p => p.id === product.id)}
                  onChange={() => {}} 
                />
                <span style={{userSelect:'none'}}>Compare</span>
              </div>

              {/* NÚT BẤM QUAN TRỌNG NHẤT Ở ĐÂY */}
              <button className="btn-view" onClick={() => onProductSelect(product)}>View Analysis</button>
            </div>
          ))
        ) : (
          <div className="no-result">
            <h3>No products found matching your filters.</h3>
          </div>
        )}
      </div>

      {totalPages > 1 && (
        <div className="pagination">
          {Array.from({ length: totalPages }, (_, i) => (
            <button 
              key={i + 1} 
              onClick={() => setCurrentPage(i + 1)}
              className={`page-btn ${currentPage === i + 1 ? 'active' : ''}`}
            >
              {i + 1}
            </button>
          ))}
        </div>
      )}
    </div>
  );
};

export default ProductList;