# /Users/kawin101/Desktop/botnoi-voice-mobile/botnoivoice/deploy.sh

#!/bin/bash

# ถ้ามี error บรรทัดไหน ให้หยุดทำงานทันที (ป้องกันการอัปไฟล์เสีย)
set -e

echo "--------------------------------------------------"
echo "🚀  STARTING AUTO DEPLOYMENT"
echo "--------------------------------------------------"

# ส่วนที่ 1: สั่ง Flutter Build (ใช้ Environment เครื่องที่ถูกต้อง)
echo "🔨 Step 1: Cleaning & Building IPA..."
flutter clean
flutter pub get
flutter build ipa --release

# ส่วนที่ 2: สั่ง Fastlane Upload
echo "📦 Step 2: Uploading to TestFlight..."
cd ios
fastlane beta

echo "--------------------------------------------------"
echo "✅  SUCCESS! Build & Upload Completed."
echo "--------------------------------------------------"