class Story {
  final String imageUrl;
  final String userName;
  final Duration duration;

  Story(
      {required this.imageUrl, required this.userName, required this.duration});
}

class Data {
  final String name;
  final String image;

  Data({required this.name, required this.image});
}

class AppDataBase {
  static List<Data> data = [
    Data(
      name: 'Mitchell',
      image:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/ava/square_ava.webp',
    ),
    Data(
      name: 'User1ss',
      image:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/bow/square_bow.webp',
    ),
    Data(
      name: 'User1',
      image:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/ngam/square_ngam.webp',
    ),
    Data(
      name: 'Aunty Grace',
      image:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/yingaiko/square_yingaiko.webp',
    ),
    Data(
      name: 'อาจารย์หลิน',
      image:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/lin/square_lin.webp',
    ),

    // Add more users and their stories
  ];
}
