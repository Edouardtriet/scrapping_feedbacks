import os
import sys
import csv
import traceback
from google_play_scraper import reviews, Sort

def extract_reviews(app_id, output_file):
    """
    Extract Google Play Store reviews and save to CSV
    """
    print(f"Starting extraction for app_id: {app_id}")
    print(f"Output file will be: {output_file}")

    try:
        # Fetch reviews
        print(f"Fetching reviews from Google Play Store for app_id: {app_id}")
        result, _ = reviews(
            app_id,
            lang='en',
            country='us',
            sort=Sort.MOST_RELEVANT,
            count=100  # Start with a smaller count for testing
        )

        print(f"Fetched {len(result)} reviews")

        # Save reviews to CSV
        print(f"Writing to file: {output_file}")
        with open(output_file, mode='w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            writer.writerow(['User Name', 'Rating', 'Content', 'Date'])
            for review in result:
                writer.writerow([
                    review['userName'],
                    review['score'],
                    review['content'],
                    review['at']
                ])
        print(f"File created successfully at {output_file}")
        return True
    except Exception as e:
        print(f"Error creating file: {str(e)}")
        traceback.print_exc()
        return False

if __name__ == "__main__":
    print(f"Python version: {sys.version}")
    print(f"Arguments received: {sys.argv}")
    
    if len(sys.argv) < 3:
        print("Usage: python extract_reviews.py <app_id> <output_file>")
        sys.exit(1)

    app_id = sys.argv[1]
    output_file = sys.argv[2]
    
    print(f"App ID: {app_id}")
    print(f"Output file: {output_file}")
    
    success = extract_reviews(app_id, output_file)
    
    if not success:
        sys.exit(1)
