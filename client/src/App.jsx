import React, { useState, useEffect } from 'react';
import ProductList from './components/ProductList';
import ProductPage from './components/ProductPage';

function App() {
  const [selectedProduct, setSelectedProduct] = useState(null);
  
  // 1. State to hold data fetched from Server
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // State for filtering & pagination
  const [currentPage, setCurrentPage] = useState(1);
  const [filters, setFilters] = useState({
    category: 'All',
    brand: 'All',
    rating: 'All'
  });

  // 2. Fetch products API when the app loads
  useEffect(() => {
    const fetchProducts = async () => {
      try {
        // Call Backend API (Port 4000)
        const response = await fetch('http://localhost:4000/api/products');
        const data = await response.json();
        
        if (data.success) {
          setProducts(data.data); 
        } else {
          setError("Failed to load data");
        }
      } catch (err) {
        console.error(err);
        setError("Error: Could not connect to Backend Server (Port 4000)");
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  // Loading Screen
  if (loading) return <div style={{padding: 50, textAlign: 'center'}}><h2>⏳ Loading Products...</h2></div>;
  
  // Error Screen
  if (error) return <div style={{padding: 50, textAlign: 'center', color: 'red'}}><h2>❌ {error}</h2></div>;

  return (
    <div style={{minHeight: '100vh', backgroundColor: '#f5f5f7'}}>
      {/* Header */}
      <div style={{
        background: '#000000', 
        padding: '15px 40px', 
        color: 'white', 
        display: 'flex', alignItems: 'center', gap: '12px', 
        boxShadow: '0 4px 12px rgba(0,0,0,0.2)'
      }}>
        <div style={{fontSize: '24px'}}>📸</div>
        <h2 style={{margin: 0, fontSize: '22px', fontWeight: '600', fontFamily: 'sans-serif'}}>
          TechNexus <span style={{fontWeight: '300', color: '#aaa'}}>Camera Store</span>
        </h2>
      </div>

      {/* Navigation Logic */}
      {selectedProduct ? (
        <ProductPage 
          product={selectedProduct} 
          onBack={() => setSelectedProduct(null)} 
        />
      ) : (
        <ProductList 
          products={products}
          onProductSelect={(product) => setSelectedProduct(product)}
          currentPage={currentPage}
          setCurrentPage={setCurrentPage}
          filters={filters}
          setFilters={setFilters}
        />
      )}
    </div>
  );
}

export default App;