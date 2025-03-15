import os
import time
import json
import boto3
import requests
from dotenv import load_dotenv
from urllib.parse import urlparse

# ระบุ Path ของไฟล์ .env
env_path = "/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/mobile_app_documents/models_data_with_python/download_image_from_url/.env"

# 🔍 1️⃣ โหลดค่าจาก .env
load_dotenv(env_path)

# 🔍 2️⃣ ตรวจสอบค่าที่โหลดจาก .env
AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = os.getenv("AWS_REGION")
BUCKET_NAME = os.getenv("AWS_S3_BUCKET")

if not all([AWS_ACCESS_KEY, AWS_SECRET_KEY, AWS_REGION, BUCKET_NAME]):
    print("❌ ERROR: Missing AWS credentials. Please check your .env file.")
    exit()

# 🔍 3️⃣ ตรวจสอบว่า JSON ไฟล์โหลดได้หรือไม่
json_file_path = '/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/assets/data/speaker_model.json'

if not os.path.exists(json_file_path):
    print(f"❌ ERROR: JSON file not found at {json_file_path}")
    exit()

try:
    with open(json_file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
except json.JSONDecodeError as e:
    print(f"❌ ERROR: Failed to parse JSON file - {e}")
    exit()

# 🔍 4️⃣ ตรวจสอบว่าโฟลเดอร์สำหรับเก็บรูปอยู่หรือไม่
folder = '/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/assets/square_image'
os.makedirs(folder, exist_ok=True)

# 🔍 5️⃣ ตรวจสอบว่า S3 Client ใช้งานได้หรือไม่
try:
    s3_client = boto3.client(
        's3',
        aws_access_key_id=AWS_ACCESS_KEY,
        aws_secret_access_key=AWS_SECRET_KEY,
        region_name=AWS_REGION
    )
    s3_client.list_buckets()  # ทดสอบว่า Client ใช้งานได้
except Exception as e:
    print(f"❌ ERROR: AWS S3 Client initialization failed - {e}")
    exit()

# Counters for success and failed downloads
total_success = 0
total_failed = 0

# 📌 ฟังก์ชันดึงเฉพาะ S3 Key จาก URL
def extract_s3_key(url):
    parsed_url = urlparse(url)
    return parsed_url.path.lstrip("/")  # ลบ `/` ที่ขึ้นต้นออก

# 📌 เช็คว่า URL เป็น S3 หรือไม่
def is_s3_url(url):
    return BUCKET_NAME in url  # ถ้า `bn-voice-pics.s3.ap-southeast-1.amazonaws.com` อยู่ใน URL แสดงว่าเป็น S3

# 📌 เช็คว่าไฟล์มีอยู่ใน S3 หรือไม่
def check_s3_file_exists(s3_key):
    try:
        s3_client.head_object(Bucket=BUCKET_NAME, Key=s3_key)
        return True
    except boto3.exceptions.botocore.exceptions.ClientError:
        return False

# 📌 ฟังก์ชันดาวน์โหลดจาก S3
def download_image_from_s3(url, folder, item_number, speaker_id):
    s3_key = extract_s3_key(url)  # ดึงเฉพาะ S3 Key
    start_time = time.time()
    file_name = f"{speaker_id}.webp"
    file_path = os.path.join(folder, file_name)

    # เช็คว่าไฟล์มีอยู่จริงก่อนดาวน์โหลด
    if not check_s3_file_exists(s3_key):
        print(f"❌ No.{item_number}: Failed to download {url}")
        return False

    try:
        # ดาวน์โหลดไฟล์จาก S3
        s3_client.download_file(BUCKET_NAME, s3_key, file_path)
        end_time = time.time()
        download_time = end_time - start_time
        print(f"✅ No.{item_number}: Downloaded {file_name} in {download_time:.2f} seconds")
        return True
    except Exception:
        print(f"❌ No.{item_number}: Failed to download {url}")
        return False

# 📌 ฟังก์ชันดาวน์โหลดจาก URL ปกติ
def download_image_from_url(url, folder, item_number, speaker_id):
    start_time = time.time()
    file_name = f"{speaker_id}.webp"
    file_path = os.path.join(folder, file_name)

    try:
        response = requests.get(url, stream=True)
        if response.status_code == 200:
            with open(file_path, 'wb') as f:
                for chunk in response.iter_content(1024):
                    f.write(chunk)
            end_time = time.time()
            download_time = end_time - start_time
            print(f"✅ No.{item_number}: Downloaded {file_name} in {download_time:.2f} seconds")
            return True
        else:
            print(f"❌ No.{item_number}: Failed to download {url} (Status Code: {response.status_code})")
            return False
    except Exception as e:
        print(f"❌ No.{item_number}: Failed to download {url} - {str(e)}")
        return False

# 📌 6️⃣ ดาวน์โหลดไฟล์ทั้งหมด
item_count = 1
if "data" not in data:
    print("❌ ERROR: 'data' key not found in JSON")
    exit()

for speaker in data.get('data', []):
    url = speaker.get('square_image', '')  # ใช้ URL เต็มรูปแบบ
    speaker_id = speaker.get('speaker_id', 'Unknown')

    if url:
        if is_s3_url(url):
            success = download_image_from_s3(url, folder, item_count, speaker_id)
        else:
            success = download_image_from_url(url, folder, item_count, speaker_id)

        if success:
            total_success += 1
        else:
            total_failed += 1

        item_count += 1

# 📌 7️⃣ แสดงผลสรุป
print("\n📌 **Download Summary**")
print(f"✅ Total Success: {total_success}")
print(f"❌ Total Failed: {total_failed}")
print(f"📊 Total Attempts: {total_success + total_failed}")
