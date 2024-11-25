  //เพิ่มสไตล์เสียง
  Set<String> selectedStyles = {};
  String selectedVoiceStyle = ''; // ตัวแปรเก็บเสียงที่ผู้ใช้เลือก
  String selectedStyle = ''; // สไตล์เสียงที่เลือก

  // ข้อมูลตัวเลือกต่าง ๆ สำหรับภาษาไทยและภาษาอังกฤษ
  // สไตล์เสียงภาษาไทย
  List<String> voiceStyle = [
    'เสียงขี้เล่น',
    'เสียงจริงจัง',
    'เสียงชัดเจน',
    'เสียงตื่นเต้น',
    'เสียงทุ้ม',
    'เสียงท้องถิ่น',
    'เสียงนิ่มนวล',
    'เสียงนุ่มนวล',
    'เสียงน่ารัก',
    'เสียงน่าเชื่อถือ',
    'เสียงมั่นใจ',
    'เสียงหวาน',
    'เสียงอบอุ่น',
    'เสียงอีสาน',
    'เสียงเหนือ',
    'เสียงใจเย็น',
    'ใต้'
  ];

    // รายการสไตล์เสียงภาษาอังกฤษ
  List<String> voiceStyleEng = [
    'Playful',
    'Serious',
    'Clear',
    'Excited',
    'Deep',
    'Regional',
    'Soft',
    'Smooth',
    'Cute',
    'Trustworthy',
    'Confident',
    'Sweet',
    'Warm',
    'Northeastern',
    'Northern',
    'Calm',
    'Southern'
  ];

    //หมวดหมู่เสียงภาษาไทย
  List<String> speechStyle = [
    'ฟรี',
    'สไตล์ตัวละคร',
    'สไตล์ท้องถิ่น',
    'สไตล์บรรยาย',
    'สไตล์สปอตโฆษณา',
    'สไตล์สารคดี',
    'สไตล์อนิเมะ',
    'สไตล์อาจารย์',
    'สไตล์อ่านข่าว',
    'สไตล์เล่าเรื่อง',
    'สไตล์เสียงต่างประเทศ',
  ];

    // หมวดหมู่เสียงภาษาอังกฤษ
  List<String> engSpeechStyle = [
    'Storytelling',
    'Narrating',
    'Free',
    'News Reading',
    'Advertising Spot',
    'Character',
    'Documentary',
    'Local',
    'Anime',
    'Foreign Voice'
  ];