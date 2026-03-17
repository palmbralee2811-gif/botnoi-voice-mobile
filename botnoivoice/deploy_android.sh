# ==========================================
# ส่วนที่ 3: สั่ง Flutter Build
# ==========================================
echo "--------------------------------------------------"
echo "🚀  STARTING PRODUCTION DEPLOYMENT (GOOGLE PLAY STORE)"
echo "--------------------------------------------------"

flutter clean
flutter pub get

flutter build apk --release
flutter build appbundle --release

echo "--------------------------------------------------"
echo "✅  SUCCESS! Build .APK and .APP Files Ready to Upload on Google Play Store."
echo "--------------------------------------------------"