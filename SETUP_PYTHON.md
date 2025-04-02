# Python Environment Setup for AppInsights

This guide will help you set up the Python environment required for the app review scraping functionality.

## Why Python?

We use Python with the `google-play-scraper` library to extract app reviews. Rails calls this Python script to fetch and analyze review data.

## Step-by-Step Setup Guide

### 1. Install Python 3

If you don't have Python installed:

- **macOS**: `brew install python`
- **Windows**: Download from [python.org](https://www.python.org/downloads/)
- **Linux**: `sudo apt-get install python3 python3-pip python3-venv`

### 2. Set Up Virtual Environment

A virtual environment keeps Python dependencies isolated from other projects:

```bash
# Navigate to your project root
cd your-project-directory

# Create virtual environment
python3 -m venv .venv

# Activate the virtual environment
# For macOS/Linux:
source .venv/bin/activate

# For Windows:
# .venv\Scripts\activate
```

### 3. Install Required Packages

Once the virtual environment is activated:

```bash
# Install packages from requirements.txt
pip install -r requirements.txt

# Verify the installation
pip list | grep google-play-scraper
```

You should see `google-play-scraper` in the list of installed packages.

### 4. Test the Python Script

Let's verify the script works correctly:

```bash
# Activate the environment if not already activated
source .venv/bin/activate

# Run the script with a test app ID
python lib/scripts/extract_reviews.py com.spotify.music test_output.csv
```

If successful, you should see output about fetching reviews and a `test_output.csv` file should be created.

## Troubleshooting

### Common Issues:

1. **"Command not found: python3"**:
   - Try using just `python` instead of `python3`
   - Ensure Python is added to your PATH

2. **"No module named google_play_scraper"**:
   - Ensure your virtual environment is activated
   - Try reinstalling with `pip install google-play-scraper`

3. **Script runs but no CSV is created**:
   - Check file permissions in your project directory
   - Verify the app ID is valid (try with known working ID like `com.spotify.music`)

4. **"No such file or directory" when running the script**:
   - Ensure you're running the command from the project root directory
   - Check if the `lib/scripts` directory exists

### Still Having Issues?

Ask for help from the team and share your terminal output to diagnose the problem.

## Every Time You Work on the Project

Remember to activate the virtual environment each time you work on the project:

```bash
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

Your terminal prompt should change to show you're using the virtual environment (typically showing `.venv` or `(.venv)` in the prompt). 