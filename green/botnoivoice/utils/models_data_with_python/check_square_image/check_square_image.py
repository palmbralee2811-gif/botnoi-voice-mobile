import json

# โหลดโค้ด JSON ที่มีอยู่
json_file_path = 'assets/data/local_image_data.json'
with open(json_file_path, 'r', encoding='utf-8') as json_file:
    json_data = json.load(json_file)

# สร้างเซ็ตเพื่อเก็บค่าที่ไม่ซ้ำกันของ square_image
unique_square_images = set()

# ตรวจสอบค่าของ square_image ที่แตกต่างจากข้อมูลอื่นโดยสิ้นเชิง
for item in json_data['data']:
    square_image = item.get('square_image')
    if square_image:
        unique_square_images.add(square_image)

# แสดงค่าที่ไม่ซ้ำกันของ square_image
print("Unique square_image values:")
for image in unique_square_images:
    print(image)