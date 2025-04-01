import os
import sys
import csv
from google_play_scraper import reviews, Sort

app_id = sys.argv[1]
output_file = sys.argv[2]

output_file = os.path.abspath(output_file)


def extract_reviews(app_id, output_file):
    print(f"Starting extraction for app_id: {app_id}")
    print(f"Output file will be: {output_file}")

    try:
        # Fetch reviews
        print("Fetching reviews...")
        result, _ = reviews(
            app_id,
            lang='en',
            country='us',
            sort=Sort.MOST_RELEVANT,  # Use Sort enum instead of string
            count=2000
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
    except Exception as e:
        print(f"Error creating file: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python extract_reviews.py <app_id> <output_file>")
        sys.exit(1)

    app_id = sys.argv[1]
    output_file = sys.argv[2]
    print(f"Arguments received: app_id={app_id}, output_file={output_file}")

    extract_reviews(app_id, output_file)
