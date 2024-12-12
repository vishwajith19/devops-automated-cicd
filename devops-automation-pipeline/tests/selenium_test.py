import os
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

# Get the URL from environment variable
url = os.getenv("TARGET_URL", "http://default.com")  # Replace 'http://default.com' with a fallback default URL

# Set up Chrome options for headless mode (if required)
chrome_options = Options()
chrome_options.add_argument("--headless")  # Remove this line if GUI is available
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")

# Initialize the WebDriver
driver = webdriver.Chrome(options=chrome_options)

try:
    # Step 1: Navigate to the dynamically provided website
    driver.get(url)

    # Define the names to look for
    names_to_check = ["DOGS", "CATS"]  # Replace with the actual names

    # Iterate over each name to verify presence and click
    for name in names_to_check:
        try:
            # Locate the element by text
            name_element = driver.find_element(By.XPATH, f"//*[text()='{name}']")
            
            # Check if the name is present
            print(f"'{name}' is present on the page.")
            
            # Click the element
            name_element.click()
            print(f"Clicked on '{name}'.")
        except Exception as e:
            print(f"'{name}' not found or could not be clicked. Error: {e}")

finally:
    # Close the WebDriver
    driver.quit()
