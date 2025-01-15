import os
import requests
import time
import json

# Path to JSON file
json_file_path = 'assets/data/response.json'

# Read the JSON file with UTF-8 encoding
with open(json_file_path, 'r', encoding='utf-8') as file:
    data = json.load(file)

# Create base download folder
base_folder = 'download_image'
os.makedirs(base_folder, exist_ok=True)

# Ensure the subfolders for each type of image exist
folders = ['image', 'face_image', 'horizontal_face_image', 'square_image']
folder_counts = {folder: 0 for folder in folders}

for folder in folders:
    os.makedirs(os.path.join(base_folder, folder), exist_ok=True)

# Function to download image from URL
def download_image(url, folder, item_number):
    start_time = time.time()
    file_name = os.path.join(folder, url.split('/')[-1])
    response = requests.get(url, stream=True)
    if response.status_code == 200:
        with open(file_name, 'wb') as f:
            for chunk in response.iter_content(1024):
                f.write(chunk)
        end_time = time.time()
        download_time = end_time - start_time
        print(f"No.{item_number}: Downloaded {file_name} in {download_time:.2f} seconds")
        return True
    else:
        print(f"No.{item_number}: Failed to download {url}")
        return False

# Iterate over each speaker and download images
item_count = 1
for speaker in data['data']:
    for folder in folders:
        if folder in speaker:
            url = speaker[folder]
            folder_path = os.path.join(base_folder, folder)
            if download_image(url, folder_path, item_count):
                folder_counts[folder] += 1
            item_count += 1

# Print the total number of images per folder and overall
total_images = sum(folder_counts.values())
print("\nDownload Summary:")
for folder, count in folder_counts.items():
    print(f"Total images in {folder}: {count}")
print(f"Total images downloaded across all folders: {total_images}")
