# กฎพื้นฐานสำหรับการเก็บคลาสและเมธอดทั้งหมดในโปรเจค
-keep class com.example.your_project.** { *; }

# เก็บคลาสที่ใช้โดย Gson
-keep class com.google.gson.** { *; }

# เก็บคลาสที่ใช้โดย Retrofit
-keepclassmembers,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# กฎสำหรับการป้องกันการลบโค้ดที่ไม่ได้ใช้งาน
-dontwarn com.example.your_project.**
