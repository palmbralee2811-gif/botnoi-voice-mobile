# การใช้งานโปรแกรม

## การติดตั้งและการใช้งาน

0. เข้าถึงตำแหน่งไฟล์
   ```bash
   cd /Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/documents/payment
   ```

1. สร้าง virtual environment:
```bash
python3 -m venv venv
```

2. เปิดใช้งาน virtual environment:
```bash
source venv/bin/activate
```

3. ติดตั้ง dependencies ที่จำเป็น:
```bash
pip install pandas
```

4. รันสคริปต์ `main.py`:
```bash
python /Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/documents/payment/main.py
```

## คำอธิบายสคริปต์

สคริปต์ `main.py` จะทำการ:
1. อ่านไฟล์ CSV ที่มีข้อมูลการชำระเงินของลูกค้า
2. เลือกเฉพาะคอลัมน์ที่ต้องการ ได้แก่ วันที่ชำระเงิน (`most_recent_purchase_at`), จำนวนเงิน (`total_spent`), และรหัสผู้ใช้ (`app_user_id`)
3. แปลงคอลัมน์วันที่จาก timestamp เป็นรูปแบบวันที่ที่อ่านง่าย
4. ปรับจำนวนทศนิยมของคอลัมน์ `total_spent` ให้เป็น 2 ตำแหน่ง
5. บันทึกผลลัพธ์ลงในไฟล์ CSV ใหม่
6. แสดงผลลัพธ์ในคอนโซล