# AppInsights - App Review Analysis

This app scrapes and analyzes app store reviews using Rails and Python integration.

## Setup Instructions

### 1. Ruby/Rails Setup
```bash
# Install Ruby dependencies
bundle install
```

### 2. Python Setup
This application uses Python for scraping app store reviews. You need to set up a Python virtual environment:

```bash
# Create a Python virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install required Python packages
pip install -r requirements.txt
```

### 3. Database Setup
```bash
# Create and migrate database
rails db:create db:migrate
```

### 4. Running the Application
```bash
# Start the Rails server
rails s
```

## Troubleshooting

### "No CSV file available for download" Error
If you encounter this error:

1. Make sure you've set up the Python environment correctly (steps above)
2. Ensure you've entered a valid Google Play Store ID (e.g., "com.spotify.music")
3. Check the server logs for Python-related errors

### Python Script Not Running
If the Python script isn't running:

1. Verify the virtual environment exists: `.venv` folder should be in your project root
2. Make sure the Python dependencies are installed: `source .venv/bin/activate && pip list`
3. Check that the `google-play-scraper` package is installed

## Deployment Notes

When deploying to Heroku, ensure both buildpacks are enabled:
```bash
heroku buildpacks:add heroku/python
heroku buildpacks:add heroku/ruby
```
