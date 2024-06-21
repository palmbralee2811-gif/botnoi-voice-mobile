class Data {
  String name;
  String image;
  
  Data({
    required this.name, 
    required this.image});
}

class AppDataBase {
 static List<Data> get data {
  return [
     Data(name: "Voice 1", image: "assets/logo/voice1.jpg"),
    Data(name: "Voice 2", image: "assets/logo/voice2.jpg"),
    Data(name: "Voice 3", image: "assets/logo/voice3.jpg"),
    Data(name: "Voice 4", image: "assets/logo/voice4.jpg"),
    Data(name: "Voice 5", image: "assets/logo/voice5.jpg"),
    Data(name: "Voice 6", image: "assets/logo/voice6.jpg"),
    Data(name: "Voice 7", image: "assets/logo/voice7.jpg"),
    Data(name: "Voice 8", image: "assets/logo/voice8.jpg"),
    Data(name: "Voice 9", image: "assets/logo/voice9.jpg"), 
    Data(name: "Voice 10", image: "assets/logo/voice9.jpg"),
  ];
 }
    
}