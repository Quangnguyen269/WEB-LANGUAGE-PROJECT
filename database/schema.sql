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
    specs JSON, -- Stores detailed specifications as JSON for flexible comparison
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
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_review (product_id, source, reviewer_name, content(50))
);

-- 3. INSERT 27 PRODUCTS WITH DETAILED SPECS
INSERT INTO products (name, price, image, rating, description, specs, category, brand) VALUES
('Canon EOS R5', '$3,899.00', '/p1.jpg', 4.9, 'The King of Mirrorless cameras.', 
 '{"Sensor": "45MP Full-Frame CMOS", "Video": "8K RAW / 4K 120p", "ISO Range": "100-51200 (Exp. 50-102400)", "Continuous Shooting": "12 fps (Mech) / 20 fps (Elec)", "Weight": "738g (Body + Battery)"}', 'Camera', 'Canon'),

('Sony Alpha 7 IV', '$2,498.00', '/p2.jpg', 4.8, 'Best Hybrid camera.', 
 '{"Sensor": "33MP Full-Frame Exmor R", "Video": "4K 60p 10-bit 4:2:2", "ISO Range": "100-51200 (Exp. 50-204800)", "Autofocus": "Real-time Eye AF (Human/Animal/Bird)", "Weight": "658g"}', 'Camera', 'Sony'),

('Fujifilm X-T5', '$1,699.00', '/p3.jpg', 4.7, 'Classic design, 40MP sensor.', 
 '{"Sensor": "40.2MP APS-C X-Trans CMOS 5 HR", "Video": "6.2K 30p / 4K 60p", "ISO Range": "125-12800 (Exp. 64-51200)", "Stabilization": "7-Stop In-Body Image Stabilization", "Weight": "557g"}', 'Camera', 'Fujifilm'),

('Nikon Z 8', '$3,996.00', '/p4.jpg', 4.9, 'The flagship monster.', 
 '{"Sensor": "45.7MP Stacked CMOS", "Video": "8K 60p N-RAW", "Continuous Shooting": "20 fps RAW / 120 fps JPEG", "Viewfinder": "Blackout-free Real-Live", "Weight": "910g"}', 'Camera', 'Nikon'),

('Leica M11', '$8,995.00', '/p5.jpg', 5.0, 'The icon of luxury.', 
 '{"Sensor": "60MP Full-Frame BSI CMOS", "Technology": "Triple Resolution Technology", "Storage": "64GB Internal Memory", "ISO Range": "64-50000", "Weight": "640g (Black Aluminum)"}', 'Camera', 'Leica'),

('Panasonic Lumix S5 II', '$1,997.00', '/p6.jpg', 4.6, 'Professional cinema quality.', 
 '{"Sensor": "24.2MP Full-Frame CMOS", "Autofocus": "Phase Hybrid AF", "Video": "6K 30p / C4K 60p", "Stabilization": "Active I.S. Technology", "Weight": "740g"}', 'Camera', 'Panasonic'),

('Hasselblad X2D 100C', '$8,199.00', '/p7.jpg', 4.9, 'Medium Format 100MP.', 
 '{"Sensor": "100MP Back-Illuminated CMOS", "Color Depth": "16-bit Color", "Storage": "1TB Built-in SSD", "Stabilization": "5-Axis 7-Stop IBIS", "Weight": "895g"}', 'Camera', 'Hasselblad'),

('Sony A6700', '$1,398.00', '/p8.jpg', 4.7, 'Best APS-C camera.', 
 '{"Sensor": "26MP APS-C Exmor R", "Processor": "BIONZ XR + AI Unit", "Video": "4K 120p / FHD 240p", "ISO Range": "100-32000", "Weight": "493g"}', 'Camera', 'Sony'),

('Canon EOS R6 II', '$2,499.00', '/p9.jpg', 4.8, 'Master of low light.', 
 '{"Sensor": "24.2MP Full-Frame CMOS", "Continuous Shooting": "40 fps (Electronic)", "Video": "4K 60p (Oversampled from 6K)", "Autofocus": "Dual Pixel CMOS AF II", "Weight": "670g"}', 'Camera', 'Canon'),

-- FILM CAMERAS
('Canon AE-1 Program', '$250.00', '/p10.jpg', 4.8, 'Film camera legend.', 
 '{"Type": "35mm SLR", "Mount": "Canon FD Mount", "Exposure Modes": "Program AE / Shutter Priority", "Viewfinder": "Pentaprism with Split Image", "Weight": "570g"}', 'Film Camera', 'Canon'),

('Leica M6 Classic', '$3,200.00', '/p11.jpg', 5.0, 'Mechanical masterpiece.', 
 '{"Type": "35mm Rangefinder", "Viewfinder": "0.72x Magnification", "Metering": "TTL Light Meter", "Operation": "Fully Mechanical", "Weight": "585g"}', 'Film Camera', 'Leica'),

('Nikon F3', '$350.00', '/p12.jpg', 4.9, 'NASA-approved durability.', 
 '{"Type": "35mm SLR", "Shutter Speed": "8s to 1/2000s", "Viewfinder": "100% Coverage", "Body Material": "Copper Silumin Aluminum", "Weight": "715g"}', 'Film Camera', 'Nikon'),

('Olympus OM-1', '$220.00', '/p13.jpg', 4.8, 'Compact SLR.', 
 '{"Type": "35mm SLR", "Size": "Ultra Compact Design", "Viewfinder": "Large & Bright", "Shutter": "Mechanical Cloth Focal Plane", "Weight": "510g"}', 'Film Camera', 'Olympus'),

('Pentax K1000', '$180.00', '/p14.jpg', 4.7, 'Student choice.', 
 '{"Type": "35mm SLR", "Operation": "Fully Manual", "Mount": "Pentax K-Mount", "Metering": "TTL Center-Weighted", "Weight": "625g"}', 'Film Camera', 'Pentax'),

('Rolleiflex 2.8F', '$2,500.00', '/p15.jpg', 5.0, 'Iconic TLR.', 
 '{"Type": "Twin Lens Reflex", "Film Format": "120 Medium Format (6x6)", "Lens": "Carl Zeiss Planar 80mm f/2.8", "Shutter": "Synchro-Compur Leaf", "Weight": "1250g"}', 'Film Camera', 'Rolleiflex'),

('Polaroid SX-70', '$350.00', '/p16.jpg', 4.5, 'The father of all instant.', 
 '{"Type": "Folding SLR Instant Camera", "Focus": "Manual / Sonar Autofocus", "Lens": "116mm f/8 Glass Lens", "Film": "Polaroid SX-70 Film", "Weight": "620g"}', 'Instant', 'Polaroid'),

('Instax Mini 12', '$79.00', '/p17.jpg', 4.6, 'Fun instant camera.', 
 '{"Type": "Instant Camera", "Film": "Instax Mini", "Exposure": "Automatic Exposure Control", "Feature": "Selfie Mirror & Close-up Mode", "Weight": "306g"}', 'Instant', 'Fujifilm'),

('Kodak Ektar H35', '$49.00', '/p18.jpg', 4.4, 'Half-frame film camera.', 
 '{"Type": "Half-Frame 35mm", "Lens": "22mm f/9.5 Acrylic", "Flash": "Built-in", "Efficiency": "72 shots per 36-exp roll", "Weight": "100g"}', 'Film Camera', 'Kodak'),

-- DRONES & ACTION
('DJI Mavic 3 Pro', '$2,199.00', '/p19.jpg', 5.0, 'Ultimate drone.', 
 '{"Camera System": "Triple Camera (Hasselblad + 2 Tele)", "Sensor": "4/3 CMOS (Main)", "Flight Time": "Max 43 mins", "Transmission": "15km O3+", "Weight": "958g"}', 'Drone', 'DJI'),

('DJI Mini 4 Pro', '$759.00', '/p20.jpg', 4.9, 'Under 249g drone.', 
 '{"Sensor": "1/1.3-inch CMOS", "Video": "4K 60fps HDR", "Obstacle Sensing": "Omnidirectional", "Feature": "True Vertical Shooting", "Weight": "<249g"}', 'Drone', 'DJI'),

('GoPro HERO12', '$399.00', '/p21.jpg', 4.5, 'Rugged action camera.', 
 '{"Video": "5.3K 60fps / 4K 120fps", "Stabilization": "HyperSmooth 6.0", "Waterproof": "Up to 33ft (10m)", "Battery": "Enduro Battery", "Weight": "154g"}', 'Action Cam', 'GoPro'),

('DJI Osmo Action 4', '$399.00', '/p22.jpg', 4.7, 'Best low light action.', 
 '{"Sensor": "1/1.3-inch CMOS", "Video": "4K 120fps", "Color Profile": "10-bit D-Log M", "Waterproof": "Up to 18m without case", "Weight": "145g"}', 'Action Cam', 'DJI'),

('Insta360 X3', '$449.00', '/p23.jpg', 4.8, '360-degree camera.', 
 '{"Resolution": "5.7K 360 Video", "Photo": "72MP 360 Photo", "Screen": "2.29-inch Touchscreen", "Waterproof": "IPX8 to 10m", "Weight": "180g"}', 'Action Cam', 'Insta360'),

('DJI Pocket 3', '$519.00', '/p24.jpg', 4.9, 'Pocket-sized gimbal.', 
 '{"Sensor": "1-inch CMOS", "Video": "4K 120fps (Slow Mo)", "Screen": "2-inch Rotatable OLED", "Stabilization": "3-Axis Mechanical Gimbal", "Weight": "179g"}', 'Action Cam', 'DJI'),

('Sony ZV-E1', '$2,198.00', '/p25.jpg', 4.6, 'Full-frame vlog camera.', 
 '{"Sensor": "12MP Full-Frame Exmor R", "AI Features": "Auto Framing & Stabilizer", "Video": "4K 60p (Upgradeable to 120p)", "Microphone": "Intelligent 3-Capsule Mic", "Weight": "483g"}', 'Camera', 'Sony'),

('Ricoh GR IIIx', '$1,049.00', '/p26.jpg', 4.8, 'Street photography.', 
 '{"Sensor": "24MP APS-C", "Lens": "40mm f/2.8 (Equiv.)", "Stabilization": "3-Axis Shake Reduction", "Size": "Pocketable Design", "Weight": "262g"}', 'Camera', 'Ricoh'),

('Sigma fp L', '$2,499.00', '/p27.jpg', 4.5, 'Smallest full-frame.', 
 '{"Sensor": "61MP Full-Frame Bayer", "Video": "12-bit CinemaDNG External", "Design": "Modular & Scalable", "Shutter": "Electronic Only", "Weight": "427g"}', 'Camera', 'Sigma');

-- 4. GENERATE RANDOM REVIEWS (Standard SQL Loop Logic)
SET SQL_SAFE_UPDATES = 0;
INSERT INTO reviews (product_id, source, reviewer_name, rating, content, review_date)
WITH RECURSIVE NumberGenerator AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM NumberGenerator WHERE n < 50
)
SELECT 
    p.id,
    ELT(FLOOR(1 + RAND() * 3), 'Amazon', 'BestBuy', 'Walmart'),
    CONCAT('User_', FLOOR(RAND() * 10000)),
    FLOOR(3 + RAND() * 3), 
    ELT(FLOOR(1 + RAND() * 5), 
        'Absolutely amazing product! Worth every penny.',
        'Good quality but shipping was a bit slow.',
        'Exceeded my expectations. Highly recommended.',
        'Decent performance for the price.',
        'I love it! Will buy again for my friend.'
    ),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY)
FROM products p
CROSS JOIN NumberGenerator;

-- 5. UPDATE REVIEW COUNTS
UPDATE products p
SET reviews_count = (SELECT COUNT(*) FROM reviews r WHERE r.product_id = p.id);
SET SQL_SAFE_UPDATES = 1;

-- 6. VERIFY
SELECT id, name, reviews_count FROM products;