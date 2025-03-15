import re
import json

# โหลดโค้ด JSON ที่มีอยู่
json_file_path = '/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/assets/data/speaker_model.json'
with open(json_file_path, 'r', encoding='utf-8') as json_file:
    json_code_content = json_file.read()
    json_data = json.loads(json_code_content)

# สร้างพจนานุกรมเพื่อจับคู่ URL ของภาพกับ speaker ID
url_to_speaker_id = {speaker['square_image']: speaker['speaker_id'] for speaker in json_data['data']}

# นับจำนวน Success และ Failed
total_success = 0
total_failed = 0

# อัปเดตฟังก์ชัน regex เพื่อจัดการกับกรณีที่มีช่องว่างหรืออักขระพิเศษในเส้นทาง URL
def update_square_image_path_extended(match):
    """
    ฟังก์ชันนี้จะอัปเดต URL ของ squareImage โดยการสร้างเส้นทางของไฟล์ในเครื่องที่สอดคล้องกัน,
    โดยจัดการกับช่องว่างและอักขระพิเศษอื่น ๆ ใน URL
    """
    url = match.group(1)
    speaker_id = url_to_speaker_id.get(url)
    if speaker_id:
        global total_success
        total_success += 1
        return f'"assets/square_image/{speaker_id}.webp"'
    
    global total_failed
    total_failed += 1
    return match.group(0)  # คืนค่าเดิมถ้าไม่พบการจับคู่

# ใช้การแทนที่ regex ที่อัปเดตเพื่อจัดการกับกรณีที่มีช่องว่างและอักขระพิเศษ
updated_json_code_content_extended = re.sub(
    r'"square_image":\s*"(https?://[^,]+square_[\w\s\(\)-\u0E00-\u0E7F]+\.webp)"',
    lambda match: f'"square_image": {update_square_image_path_extended(match)}',
    json_code_content,
    flags=re.UNICODE
)

# บันทึกโค้ด JSON ที่แก้ไขเพิ่มเติม
updated_json_file_path_extended = '/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/assets/data/speaker_model.json'
with open(updated_json_file_path_extended, 'w', encoding='utf-8') as updated_json_file_extended:
    updated_json_file_extended.write(updated_json_code_content_extended)

# แสดงผลลัพธ์สรุป
print("\n📌 **Summary**")
print(f"✅ Total Success: {total_success}")
print(f"❌ Total Failed: {total_failed}")
print(f"📊 Total Attempts: {total_success + total_failed}")

print(f"🎉 Update URL Image to Local Image Path Successfully.")
