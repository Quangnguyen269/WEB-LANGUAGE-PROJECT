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
    specs JSON,
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

-- 3. INSERT PRODUCTS
INSERT INTO products (name, price, image, rating, description, specs, category, brand) VALUES
('Canon EOS R5', '$3,899.00', '/p1.jpg', 4.9, 'The King of Mirrorless cameras.', '{"Sensor": "45MP Full-Frame", "Video": "8K RAW", "Weight": "738g"}', 'Camera', 'Canon'),
('Sony Alpha 7 IV', '$2,498.00', '/p2.jpg', 4.8, 'Best Hybrid camera.', '{"Sensor": "33MP Full-Frame", "Video": "4K 60p", "Weight": "658g"}', 'Camera', 'Sony'),
('Fujifilm X-T5', '$1,699.00', '/p3.jpg', 4.7, 'Classic design, 40MP sensor.', '{"Sensor": "40MP APS-C", "Video": "6.2K 30p", "Weight": "557g"}', 'Camera', 'Fujifilm'),
('Nikon Z 8', '$3,996.00', '/p4.jpg', 4.9, 'The flagship monster.', '{"Sensor": "45.7MP Stacked", "Video": "8K 60p", "Weight": "910g"}', 'Camera', 'Nikon'),
('Leica M11', '$8,995.00', '/p5.jpg', 5.0, 'The icon of luxury.', '{"Sensor": "60MP BSI", "Storage": "64GB Internal", "Weight": "640g"}', 'Camera', 'Leica'),
('Panasonic Lumix S5 II', '$1,997.00', '/p6.jpg', 4.6, 'Professional cinema quality.', '{"Sensor": "24MP Full-Frame", "Video": "6K 30p", "Weight": "740g"}', 'Camera', 'Panasonic'),
('Hasselblad X2D', '$8,199.00', '/p7.jpg', 4.9, 'Medium Format 100MP.', '{"Sensor": "100MP Medium Format", "Color": "16-bit", "Weight": "895g"}', 'Camera', 'Hasselblad'),
('Sony A6700', '$1,398.00', '/p8.jpg', 4.7, 'Best APS-C camera.', '{"Sensor": "26MP APS-C", "Video": "4K 120p", "Weight": "493g"}', 'Camera', 'Sony'),
('Canon EOS R6 II', '$2,499.00', '/p9.jpg', 4.8, 'Master of low light.', '{"Sensor": "24MP Full-Frame", "Speed": "40 fps", "Weight": "670g"}', 'Camera', 'Canon'),
('Canon AE-1 Program', '$250.00', '/p10.jpg', 4.8, 'Film camera legend.', '{"Type": "35mm SLR", "Focus": "Manual", "Weight": "570g"}', 'Film Camera', 'Canon'),
('Leica M6 Classic', '$3,200.00', '/p11.jpg', 5.0, 'Mechanical masterpiece.', '{"Type": "Rangefinder", "Operation": "Mechanical", "Weight": "585g"}', 'Film Camera', 'Leica'),
('Nikon F3', '$350.00', '/p12.jpg', 4.9, 'NASA-approved durability.', '{"Type": "35mm SLR", "Body": "Titanium", "Weight": "715g"}', 'Film Camera', 'Nikon'),
('Olympus OM-1', '$220.00', '/p13.jpg', 4.8, 'Compact SLR.', '{"Type": "35mm SLR", "Viewfinder": "Large", "Weight": "510g"}', 'Film Camera', 'Olympus'),
('Pentax K1000', '$180.00', '/p14.jpg', 4.7, 'Student choice.', '{"Type": "35mm SLR", "Operation": "Fully Manual", "Weight": "625g"}', 'Film Camera', 'Pentax'),
('Rolleiflex 2.8F', '$2,500.00', '/p15.jpg', 5.0, 'Iconic TLR.', '{"Type": "Twin Lens Reflex", "Film": "120 Format", "Weight": "1250g"}', 'Film Camera', 'Rolleiflex'),
('Polaroid SX-70', '$350.00', '/p16.jpg', 4.5, 'The father of all instant.', '{"Type": "Instant SLR", "Focus": "Sonar", "Weight": "620g"}', 'Instant', 'Polaroid'),
('Instax Mini 12', '$79.00', '/p17.jpg', 4.6, 'Fun instant camera.', '{"Type": "Instant", "Exposure": "Auto", "Weight": "306g"}', 'Instant', 'Fujifilm'),
('Kodak Ektar H35', '$49.00', '/p18.jpg', 4.4, 'Half-frame film camera.', '{"Type": "Half-Frame", "Shots": "72/roll", "Weight": "100g"}', 'Film Camera', 'Kodak'),
('DJI Mavic 3 Pro', '$2,199.00', '/p19.jpg', 5.0, 'Ultimate drone.', '{"Camera": "Triple Lens", "Flight Time": "43 mins", "Weight": "958g"}', 'Drone', 'DJI'),
('DJI Mini 4 Pro', '$759.00', '/p20.jpg', 4.9, 'Under 249g drone.', '{"Video": "4K 60p HDR", "Weight": "<249g", "Feature": "Vertical"}', 'Drone', 'DJI'),
('GoPro HERO12', '$399.00', '/p21.jpg', 4.5, 'Rugged action camera.', '{"Video": "5.3K 60p", "Waterproof": "10m", "Weight": "154g"}', 'Action Cam', 'GoPro'),
('DJI Osmo Action 4', '$399.00', '/p22.jpg', 4.7, 'Best low light action.', '{"Sensor": "1/1.3 inch", "Video": "4K 120p", "Weight": "145g"}', 'Action Cam', 'DJI'),
('Insta360 X3', '$449.00', '/p23.jpg', 4.8, '360-degree camera.', '{"Resolution": "5.7K 360", "Waterproof": "10m", "Weight": "180g"}', 'Action Cam', 'Insta360'),
('DJI Pocket 3', '$519.00', '/p24.jpg', 4.9, 'Pocket-sized gimbal.', '{"Sensor": "1-inch", "Stabilization": "3-Axis", "Weight": "179g"}', 'Action Cam', 'DJI'),
('Sony ZV-E1', '$2,198.00', '/p25.jpg', 4.6, 'Full-frame vlog camera.', '{"Sensor": "12MP Full-Frame", "AI": "Auto Framing", "Weight": "483g"}', 'Camera', 'Sony'),
('Ricoh GR IIIx', '$1,049.00', '/p26.jpg', 4.8, 'Street photography.', '{"Sensor": "24MP APS-C", "Lens": "40mm", "Weight": "262g"}', 'Camera', 'Ricoh'),
('Sigma fp L', '$2,499.00', '/p27.jpg', 4.5, 'Smallest full-frame.', '{"Sensor": "61MP Full-Frame", "Video": "CinemaDNG", "Weight": "427g"}', 'Camera', 'Sigma');

-- 4. GENERATE REVIEWS (Loop to randomize count & ratings)
DELIMITER $$

CREATE PROCEDURE GenerateReviews()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE j INT;
    DECLARE review_limit INT;
    DECLARE forced_rating INT;
    
    WHILE i <= 27 DO
        -- Randomize review count between 50 and 100
        SET review_limit = FLOOR(50 + (RAND() * 51));
        SET j = 1;

        -- FORCED RATING LOGIC:
        -- Products 25, 26, 27 -> Mostly 3 Stars (Low Rating)
        -- Products 20, 21, 22, 23, 24 -> Mostly 4 Stars (Good Rating)
        -- Others (1-19) -> Mostly 5 Stars (Excellent)

        WHILE j <= review_limit DO
            IF i >= 25 THEN
                -- 3 Star Group (3 products)
                SET forced_rating = IF(RAND() < 0.8, 3, 2); 
            ELSEIF i >= 20 THEN
                -- 4 Star Group (5 products)
                SET forced_rating = IF(RAND() < 0.8, 4, 3);
            ELSE
                -- 5 Star Group (The rest)
                SET forced_rating = IF(RAND() < 0.8, 5, 4);
            END IF;

            INSERT INTO reviews (product_id, source, reviewer_name, rating, content, review_date)
            VALUES (
                i,
                ELT(FLOOR(1 + RAND() * 3), 'Amazon', 'BestBuy', 'Walmart'),
                CONCAT('User_', FLOOR(RAND() * 10000)),
                forced_rating,
                ELT(FLOOR(1 + RAND() * 5), 'Amazing!', 'Good value.', 'Okay.', 'Not great.', 'Fast shipping.'),
                DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY)
            );
            SET j = j + 1;
        END WHILE;
        
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- 5. EXECUTE & SYNC
CALL GenerateReviews();

SET SQL_SAFE_UPDATES = 0;
UPDATE products p
SET 
    reviews_count = (SELECT COUNT(*) FROM reviews r WHERE r.product_id = p.id),
    rating = (SELECT AVG(rating) FROM reviews r WHERE r.product_id = p.id);
SET SQL_SAFE_UPDATES = 1;

-- 6. VERIFY
SELECT id, name, rating, reviews_count FROM products;