// server/src/services/mockScraper.js

const SOURCES = ['Amazon', 'BestBuy', 'Walmart', 'Target', 'Ebay'];

// Sample review content to prevent repetitive text
const CONTENTS = [
    'Absolutely amazing quality! Worth every penny.',
    'Shipping was super fast. The packaging was secure.',
    'Battery life is better than I expected.',
    'A bit expensive, but you get what you pay for.',
    'Focus is blazing fast. Highly recommended!',
    'Good product, but the menu system is confusing.',
    'I upgraded from the previous model and I am happy.',
    'Build quality is top notch. Feels solid in hand.',
    'Not bad, but there are cheaper alternatives.',
    'Customer service was helpful when I had questions.',
    'The color accuracy is incredible.',
    'Low light performance is a game changer.',
    'It overheats a little if you use it too long.',
    'Perfect for my needs. 5 stars!',
    'I returned it because it was too heavy.'
];

const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function fetchReviewsFromSources(productId) {
    console.log(`[Scraper] Fetching reviews for Product ID: ${productId}...`);
    
    // Simulate network delay (1 second)
    await delay(1000); 

    // Generate random number of reviews (5 to 10 per fetch)
    const count = Math.floor(Math.random() * 6) + 5; 
    
    const newReviews = [];

    for (let i = 0; i < count; i++) {
        const source = SOURCES[Math.floor(Math.random() * SOURCES.length)];
        newReviews.push({
            source: source,
            // Generate random reviewer name
            reviewer_name: `User-${Math.floor(Math.random() * 10000)}`,
            // Random rating between 3 and 5 (biased towards positive)
            rating: Math.floor(Math.random() * 3) + 3, 
            // Select random content
            content: CONTENTS[Math.floor(Math.random() * CONTENTS.length)],
            review_date: new Date().toISOString().split('T')[0],
            fetched_at: new Date()
        });
    }

    return newReviews;
}

module.exports = { fetchReviewsFromSources };