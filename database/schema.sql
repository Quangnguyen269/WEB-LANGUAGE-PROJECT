-- 1. CLEANUP (Drop old database to ensure a fresh start)
DROP DATABASE IF EXISTS review_db;
CREATE DATABASE review_db;
USE review_db;

-- 2. Create Products Table
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

-- 3. Create Reviews Table
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

-- 4. SEED DATA (27 Products)
INSERT INTO products (name, price, image, rating, reviews_count, description, category, brand) VALUES
('Canon EOS R5', '$3,899.00', '/p1.jpg', 4.9, 0, 'The King of Mirrorless cameras, 8K RAW video.', 'Camera', 'Canon'),
('Sony Alpha 7 IV', '$2,498.00', '/p2.jpg', 4.8, 0, 'Best Hybrid camera for both professional photography.', 'Camera', 'Sony'),
('Fujifilm X-T5', '$1,699.00', '/p3.jpg', 4.7, 0, 'Classic design, 40MP sensor, Film Simulations.', 'Camera', 'Fujifilm'),
('Nikon Z 8', '$3,996.00', '/p4.jpg', 4.9, 0, 'The flagship monster. Unstoppable performance.', 'Camera', 'Nikon'),
('Leica M11', '$8,995.00', '/p5.jpg', 5.0, 0, 'The icon of luxury and street photography.', 'Camera', 'Leica'),
('Panasonic Lumix S5 II', '$1,997.00', '/p6.jpg', 4.6, 0, 'Professional cinema quality in a compact body.', 'Camera', 'Panasonic'),
('Hasselblad X2D', '$8,199.00', '/p7.jpg', 4.9, 0, 'Medium Format 100MP, incredible detail.', 'Camera', 'Hasselblad'),
('Sony A6700', '$1,398.00', '/p8.jpg', 4.7, 0, 'Best APS-C camera from Sony with AI autofocus.', 'Camera', 'Sony'),
('Canon EOS R6 II', '$2,499.00', '/p9.jpg', 4.8, 0, 'Master of low light and high-speed action.', 'Camera', 'Canon'),
('Canon AE-1 Program', '$250.00', '/p10.jpg', 4.8, 0, 'The most popular film camera legend.', 'Film Camera', 'Canon'),
('Leica M6 Classic', '$3,200.00', '/p11.jpg', 5.0, 0, 'A mechanical masterpiece. Rangefinder standard.', 'Film Camera', 'Leica'),
('Nikon F3', '$350.00', '/p12.jpg', 4.9, 0, 'NASA-approved durability. Toughest film camera.', 'Film Camera', 'Nikon'),
('Olympus OM-1', '$220.00', '/p13.jpg', 4.8, 0, 'Compact, elegant SLR with a huge viewfinder.', 'Film Camera', 'Olympus'),
('Pentax K1000', '$180.00', '/p14.jpg', 4.7, 0, 'Student choice. Fully mechanical workhorse.', 'Film Camera', 'Pentax'),
('Rolleiflex 2.8F', '$2,500.00', '/p15.jpg', 5.0, 0, 'Iconic Twin Lens Reflex camera.', 'Film Camera', 'Rolleiflex'),
('Polaroid SX-70', '$350.00', '/p16.jpg', 4.5, 0, 'The father of all instant cameras.', 'Instant', 'Polaroid'),
('Instax Mini 12', '$79.00', '/p17.jpg', 4.6, 0, 'Fun instant camera for parties.', 'Instant', 'Fujifilm'),
('Kodak Ektar H35', '$49.00', '/p18.jpg', 4.4, 0, 'Half-frame film camera. Double the photos.', 'Film Camera', 'Kodak'),
('DJI Mavic 3 Pro', '$2,199.00', '/p19.jpg', 5.0, 0, 'Ultimate drone with triple-camera system.', 'Drone', 'DJI'),
('DJI Mini 4 Pro', '$759.00', '/p20.jpg', 4.9, 0, 'Under 249g, True Vertical Shooting.', 'Drone', 'DJI'),
('GoPro HERO12', '$399.00', '/p21.jpg', 4.5, 0, 'Rugged action camera with HyperSmooth.', 'Action Cam', 'GoPro'),
('DJI Osmo Action 4', '$399.00', '/p22.jpg', 4.7, 0, 'Best-in-class low light performance.', 'Action Cam', 'DJI'),
('Insta360 X3', '$449.00', '/p23.jpg', 4.8, 0, '360-degree action camera.', 'Action Cam', 'Insta360'),
('DJI Pocket 3', '$519.00', '/p24.jpg', 4.9, 0, 'Pocket-sized gimbal camera.', 'Action Cam', 'DJI'),
('Sony ZV-E1', '$2,198.00', '/p25.jpg', 4.6, 0, 'Full-frame vlog camera.', 'Camera', 'Sony'),
('Ricoh GR IIIx', '$1,049.00', '/p26.jpg', 4.8, 0, 'Street photography camera.', 'Camera', 'Ricoh'),
('Sigma fp L', '$2,499.00', '/p27.jpg', 4.5, 0, 'Smallest full-frame camera.', 'Camera', 'Sigma');