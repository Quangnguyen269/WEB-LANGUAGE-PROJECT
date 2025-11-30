import React, { useState, useEffect } from 'react';
import ProductList from './components/ProductList';
import ProductPage from './components/ProductPage';

function App() {
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const [currentPage, setCurrentPage] = useState(1);
  const [filters, setFilters] = useState({
    category: 'All',
    brand: 'All',
    rating: 'All'
  });

  // --- STATE SO SÁNH ---
  const [compareList, setCompareList] = useState([]);

  const toggleCompare = (product) => {
    // Kiểm tra xem sản phẩm đã có trong list chưa
    if (compareList.find(p => p.id === product.id)) {
      // Nếu có rồi -> Xóa ra (Uncheck)
      setCompareList(compareList.filter(p => p.id !== product.id));
    } else {
      // Nếu chưa có -> Thêm vào (Check)
      if (compareList.length >= 3) {
        alert("You can only compare up to 3 products.");
        return;
      }
      setCompareList([...compareList, product]);
    }
  };

  // Helper đọc thông số kỹ thuật từ JSON
  const getSpecValue = (product, key) => {
    try {
      const specs = typeof product.specs === 'string' ? JSON.parse(product.specs) : product.specs;
      return specs && specs[key] ? specs[key] : '-';
    } catch (e) { return '-'; }
  };

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const response = await fetch('http://localhost:4000/api/products');
        const data = await response.json();
        if (data.success) setProducts(data.data);
        else setError("Failed to load data");
      } catch (err) {
        console.error(err);
        setError("Error: Could not connect to Backend Server (Port 4000)");
      } finally {
        setLoading(false);
      }
    };
    fetchProducts();
  }, []);

  if (loading) return <div style={{padding: 50, textAlign: 'center'}}><h2>⏳ Loading Products...</h2></div>;
  if (error) return <div style={{padding: 50, textAlign: 'center', color: 'red'}}><h2>❌ {error}</h2></div>;

  return (
    <div style={{minHeight: '100vh', backgroundColor: '#f5f5f7', paddingBottom: compareList.length > 0 ? '280px' : '0'}}>
      {/* Header */}
      <div style={{
        background: '#000000', padding: '15px 40px', color: 'white', 
        display: 'flex', alignItems: 'center', gap: '12px', 
        boxShadow: '0 4px 12px rgba(0,0,0,0.2)'
      }}>
        <div style={{fontSize: '24px'}}>📸</div>
        <h2 style={{margin: 0, fontSize: '22px', fontWeight: '600', fontFamily: 'sans-serif'}}>
          TechNexus <span style={{fontWeight: '300', color: '#aaa'}}>Camera Store</span>
        </h2>
      </div>

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
          // TRUYỀN PROPS SO SÁNH XUỐNG
          compareList={compareList}
          toggleCompare={toggleCompare}
        />
      )}

      {/* --- THANH SO SÁNH NỔI (FLOATING BAR) --- */}
      {compareList.length > 0 && !selectedProduct && (
        <div style={{
          position: 'fixed', bottom: 0, left: 0, right: 0, 
          background: 'white', borderTop: '4px solid #0071e3', 
          padding: '20px', boxShadow: '0 -10px 40px rgba(0,0,0,0.2)', zIndex: 999,
          height: '260px', overflowY: 'hidden'
        }}>
          <div style={{maxWidth: '1200px', margin: '0 auto', height: '100%'}}>
             <div style={{display:'flex', justifyContent:'space-between', marginBottom:'10px', alignItems:'center'}}>
               <h3 style={{margin:0, fontSize:'18px', color:'#333'}}>⚖️ Comparison ({compareList.length}/3)</h3>
               <button onClick={() => setCompareList([])} style={{color:'red', background:'none', border:'1px solid red', padding:'4px 10px', borderRadius:'4px', cursor:'pointer', fontWeight:'bold', fontSize:'12px'}}>Clear All</button>
             </div>
             
             <div style={{display: 'grid', gridTemplateColumns: `repeat(${compareList.length}, 1fr)`, gap: '15px', height: '180px'}}>
                {compareList.map(p => (
                  <div key={p.id} style={{border:'1px solid #ddd', padding:'10px', borderRadius:'8px', background:'#f8f9fa', display:'flex', flexDirection:'column'}}>
                    <div style={{fontWeight:'bold', fontSize:'14px', marginBottom:'5px', whiteSpace:'nowrap', overflow:'hidden', textOverflow:'ellipsis'}}>{p.name}</div>
                    <div style={{color:'#0071e3', fontWeight:'bold', fontSize:'13px', marginBottom:'8px'}}>{p.price}</div>
                    
                    {/* HIỂN THỊ THÔNG SỐ SO SÁNH */}
                    <div style={{fontSize:'11px', color:'#444', flex:1, display:'flex', flexDirection:'column', gap:'4px', background:'white', padding:'8px', borderRadius:'4px'}}>
                        {/* Tự động hiện thông số dựa theo loại sản phẩm */}
                        <div><strong>Sensor:</strong> {getSpecValue(p, 'Sensor') || getSpecValue(p, 'Camera')}</div>
                        <div><strong>Video:</strong> {getSpecValue(p, 'Video')}</div>
                        <div><strong>Weight:</strong> {getSpecValue(p, 'Weight')}</div>
                        <div>⭐ {p.rating} ({p.reviews_count} reviews)</div>
                    </div>
                  </div>
                ))}
             </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default App;