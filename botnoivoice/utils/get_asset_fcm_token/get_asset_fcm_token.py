import json
from google.auth.transport.requests import Request
from google.oauth2 import service_account

# กำหนด path ของไฟล์ service account JSON
# SERVICE_ACCOUNT_FILE = "coding-website-fcm.json"


# ถ้าเปลี่ยนชื่อไฟล์ ต้องเปลี่ยนใน `.gitignore` ด้วย เพื่อให้ Token ไม่ถูกเผยแพร่ บน GitHub
# If you change the file name, you must also change it in `.gitignore` so that the Token is not exposed on GitHub
SERVICE_ACCOUNT_FILE = "botnoivoice-firebase-admin-sdk.json"

def get_access_token():
    try:
        # โหลด credentials จากไฟล์ JSON
        credentials = service_account.Credentials.from_service_account_file(
            SERVICE_ACCOUNT_FILE,
            scopes=["https://www.googleapis.com/auth/firebase.messaging"]
        )

        # รีเฟรช token หากหมดอายุ
        credentials.refresh(Request())

        return credentials.token
    except Exception as e:
        print(f"Error getting access token: {e}")
        return None

# ตัวอย่างการใช้งาน
if __name__ == "__main__":
    token = get_access_token()
    if token:
        print("Access Token:", token)
    else:
        print("Failed to retrieve access token")