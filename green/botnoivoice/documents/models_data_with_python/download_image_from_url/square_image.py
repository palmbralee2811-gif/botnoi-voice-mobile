import os
import requests
import time
import json

# Path to JSON file
json_file_path = '/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/assets/data/response.json'

# Read the JSON file with UTF-8 encoding
with open(json_file_path, 'r', encoding='utf-8') as file:
    data = json.load(file)

# Create download folder for square_image
folder = 'download_image/square_image'
os.makedirs(folder, exist_ok=True)

# Function to download image from URL
def download_image(url, folder, item_number, speaker_id):
    start_time = time.time()
    file_name = f"{speaker_id}.webp"
    file_path = os.path.join(folder, file_name)
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(file_path, 'wb') as f:
            for chunk in response.iter_content(1024):
                f.write(chunk)
        end_time = time.time()
        download_time = end_time - start_time
        print(f"No.{item_number}: Downloaded {file_name} in {download_time:.2f} seconds")
        return True
    else:
        print(f"No.{item_number}: Failed to download {url}")
        return False

# Iterate over each speaker and download only square_image
item_count = 1
total_images = 0
for speaker in data['data']:
    if 'square_image' in speaker:
        url = speaker['square_image']
        speaker_id = speaker['speaker_id']
        if download_image(url, folder, item_count, speaker_id):
            total_images += 1
        item_count += 1

# Print the total number of downloaded images
print("\nDownload Summary:")
print(f"Total square images downloaded: {total_images}")