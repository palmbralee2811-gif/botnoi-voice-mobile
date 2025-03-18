#!/bin/bash

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
source venv/bin/activate

# Install the required packages
pip install -r /Users/kawin101/Desktop/botnoi-voice-mobile/botnoivoice/utils/get_asset_fcm_token/requirements.txt

# Get the FCM token of the asset
python /Users/kawin101/Desktop/botnoi-voice-mobile/botnoivoice/utils/get_asset_fcm_token/get_asset_fcm_token.py

# Deactivate the virtual environment
deactivate


