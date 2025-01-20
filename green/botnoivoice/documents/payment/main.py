import pandas as pd

# อ่านไฟล์ CSV
df = pd.read_csv('/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/documents/payment/data/non_subscription.csv', delimiter=';')

# เลือกเฉพาะคอลัมน์ที่ต้องการ
df_filtered = df[['most_recent_purchase_at', 'total_spent', 'app_user_id']]

# แปลงคอลัมน์วันที่จาก timestamp เป็นรูปแบบวันที่
df_filtered['most_recent_purchase_at'] = pd.to_datetime(df_filtered['most_recent_purchase_at'], unit='ms')

# ปรับจำนวนทศนิยมของคอลัมน์ total_spent ให้เป็น 2 ตำแหน่ง
df_filtered['total_spent'] = df_filtered['total_spent'].round(2)

# บันทึกผลลัพธ์ลงไฟล์ CSV
df_filtered.to_csv('/Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/documents/payment/data/filtered_non_subscription.csv', index=False)

# แสดงผลลัพธ์
print(df_filtered)