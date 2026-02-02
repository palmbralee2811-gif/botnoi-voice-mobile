# /Users/kawin101/Desktop/botnoi-voice-mobile/botnoivoice/deploy_production.sh

#!/bin/bash

# :x: ถ้ามี error บรรทัดไหน ให้หยุดทำงานทันที (ป้องกันการอัปไฟล์เสีย)
set -e

echo "--------------------------------------------------"
echo "🚀  STARTING PRODUCTION DEPLOYMENT (APP STORE)"
echo "--------------------------------------------------"

# ==========================================
# ส่วนที่ 1: สั่ง Flutter Build
# ==========================================
echo "🔨 Step 1: Cleaning & Building IPA (Release)..."

# ล้างค่าเก่าทิ้งเพื่อความชัวร์
flutter clean
flutter pub get

# Build ไฟล์ .ipa
flutter build ipa --release

# ==========================================
# ส่วนที่ 2: สั่ง Fastlane Upload (ไปช่อง Release)
# ==========================================
echo "📦 Step 2: Uploading to App Store Connect..."

# เข้าโฟลเดอร์ ios
cd ios

# เรียกเลน release ที่เราเพิ่งสร้างใน Fastfile
fastlane release

echo "--------------------------------------------------"
echo "✅  SUCCESS! Sent to App Store for Review."
echo "--------------------------------------------------"