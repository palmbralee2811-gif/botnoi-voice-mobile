#!/bin/bash

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install the required packages
pip install -r /Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/mobile_app_documents/requirements.txt

# Download the image from the URL
python /Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/mobile_app_documents/models_data_with_python/download_image_from_url/square_image.py

# Convert image from URL to local image
python /Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/mobile_app_documents/models_data_with_python/url_image_to_local_image/url_image_to_local_image.py

# Deactivate the virtual environment
deactivate