-- 1. CLEANUP
DROP DATABASE IF EXISTS review_db;
CREATE DATABASE review_db;
USE review_db;

-- 2. CREATE TABLES
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price VARCHAR(50),
    image VARCHAR(255),
    rating DECIMAL(3, 1),
    reviews_count INT DEFAULT 0,
    description TEXT,
    category VARCHAR(50),
    brand VARCHAR(50)
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    source VARCHAR(50),
    reviewer_name VARCHAR(100),
    rating INT,
    content TEXT,
    review_date DATE,
    fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- 3. INSERT 27 PRODUCTS
INSERT INTO products (name, price, image, rating, description, category, brand) VALUES
('Canon EOS R5', '$3,899.00', '/p1.jpg', 4.9, 'The King of Mirrorless cameras, 8K RAW video.', 'Camera', 'Canon'),
('Sony Alpha 7 IV', '$2,498.00', '/p2.jpg', 4.8, 'Best Hybrid camera for both professional photography.', 'Camera', 'Sony'),
('Fujifilm X-T5', '$1,699.00', '/p3.jpg', 4.7, 'Classic design, 40MP sensor, Film Simulations.', 'Camera', 'Fujifilm'),
('Nikon Z 8', '$3,996.00', '/p4.jpg', 4.9, 'The flagship monster. Unstoppable performance.', 'Camera', 'Nikon'),
('Leica M11', '$8,995.00', '/p5.jpg', 5.0, 'The icon of luxury and street photography.', 'Camera', 'Leica'),
('Panasonic Lumix S5 II', '$1,997.00', '/p6.jpg', 4.6, 'Professional cinema quality in a compact body.', 'Camera', 'Panasonic'),
('Hasselblad X2D', '$8,199.00', '/p7.jpg', 4.9, 'Medium Format 100MP, incredible detail.', 'Camera', 'Hasselblad'),
('Sony A6700', '$1,398.00', '/p8.jpg', 4.7, 'Best APS-C camera from Sony with AI autofocus.', 'Camera', 'Sony'),
('Canon EOS R6 II', '$2,499.00', '/p9.jpg', 4.8, 'Master of low light and high-speed action.', 'Camera', 'Canon'),
('Canon AE-1 Program', '$250.00', '/p10.jpg', 4.8, 'The most popular film camera legend.', 'Film Camera', 'Canon'),
('Leica M6 Classic', '$3,200.00', '/p11.jpg', 5.0, 'A mechanical masterpiece. Rangefinder standard.', 'Film Camera', 'Leica'),
('Nikon F3', '$350.00', '/p12.jpg', 4.9, 'NASA-approved durability. Toughest film camera.', 'Film Camera', 'Nikon'),
('Olympus OM-1', '$220.00', '/p13.jpg', 4.8, 'Compact, elegant SLR with a huge viewfinder.', 'Film Camera', 'Olympus'),
('Pentax K1000', '$180.00', '/p14.jpg', 4.7, 'Student choice. Fully mechanical workhorse.', 'Film Camera', 'Pentax'),
('Rolleiflex 2.8F', '$2,500.00', '/p15.jpg', 5.0, 'Iconic Twin Lens Reflex camera.', 'Film Camera', 'Rolleiflex'),
('Polaroid SX-70', '$350.00', '/p16.jpg', 4.5, 'The father of all instant cameras.', 'Instant', 'Polaroid'),
('Instax Mini 12', '$79.00', '/p17.jpg', 4.6, 'Fun instant camera for parties.', 'Instant', 'Fujifilm'),
('Kodak Ektar H35', '$49.00', '/p18.jpg', 4.4, 'Half-frame film camera. Double the photos.', 'Film Camera', 'Kodak'),
('DJI Mavic 3 Pro', '$2,199.00', '/p19.jpg', 5.0, 'Ultimate drone with triple-camera system.', 'Drone', 'DJI'),
('DJI Mini 4 Pro', '$759.00', '/p20.jpg', 4.9, 'Under 249g, True Vertical Shooting.', 'Drone', 'DJI'),
('GoPro HERO12', '$399.00', '/p21.jpg', 4.5, 'Rugged action camera with HyperSmooth.', 'Action Cam', 'GoPro'),
('DJI Osmo Action 4', '$399.00', '/p22.jpg', 4.7, 'Best-in-class low light performance.', 'Action Cam', 'DJI'),
('Insta360 X3', '$449.00', '/p23.jpg', 4.8, '360-degree action camera.', 'Action Cam', 'Insta360'),
('DJI Pocket 3', '$519.00', '/p24.jpg', 4.9, 'Pocket-sized gimbal camera.', 'Action Cam', 'DJI'),
('Sony ZV-E1', '$2,198.00', '/p25.jpg', 4.6, 'Full-frame vlog camera.', 'Camera', 'Sony'),
('Ricoh GR IIIx', '$1,049.00', '/p26.jpg', 4.8, 'Street photography camera.', 'Camera', 'Ricoh'),
('Sigma fp L', '$2,499.00', '/p27.jpg', 4.5, 'Smallest full-frame camera.', 'Camera', 'Sigma');

-- 4. GENERATE RANDOM REVIEWS (50 to 100 per product)
DELIMITER $$

CREATE PROCEDURE GenerateRandomReviews()
BEGIN
    DECLARE prod_id INT DEFAULT 1;
    DECLARE rev_idx INT;
    DECLARE rev_limit INT;
    
    -- Loop through all 27 products
    WHILE prod_id <= 27 DO
        -- Random number between 50 and 100 for THIS product
        SET rev_limit = FLOOR(50 + (RAND() * 51)); 
        SET rev_idx = 1;
        
        -- Insert reviews for this product
        WHILE rev_idx <= rev_limit DO
            INSERT INTO reviews (product_id, source, reviewer_name, rating, content, review_date)
            VALUES (
                prod_id,
                ELT(FLOOR(1 + RAND() * 3), 'Amazon', 'BestBuy', 'Walmart'),
                CONCAT('User_', FLOOR(RAND() * 10000)),
                FLOOR(3 + RAND() * 3), -- Random Rating 3-5
                ELT(FLOOR(1 + RAND() * 5), 
                    'Absolutely amazing product! Worth every penny.',
                    'Good quality but shipping was a bit slow.',
                    'Exceeded my expectations. Highly recommended.',
                    'Decent performance for the price.',
                    'I love it! Will buy again for my friend.'
                ),
                DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY)
            );
            SET rev_idx = rev_idx + 1;
        END WHILE;
        
        SET prod_id = prod_id + 1;
    END WHILE;
END$$

DELIMITER ;

-- 5. EXECUTE THE GENERATOR
CALL GenerateRandomReviews();

-- 6. UPDATE COUNTS (To match the real data we just generated)
SET SQL_SAFE_UPDATES = 0;
UPDATE products p
SET reviews_count = (SELECT COUNT(*) FROM reviews r WHERE r.product_id = p.id);
SET SQL_SAFE_UPDATES = 1;

-- 7. VERIFY RESULTS
SELECT id, name, reviews_count FROM products;