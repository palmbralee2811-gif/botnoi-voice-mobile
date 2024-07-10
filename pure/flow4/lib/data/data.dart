class Story {
  final String imageUrl;
  final String userName;
  final Duration duration;

  Story({required this.imageUrl, required this.userName, required this.duration});
}

class Data {
  final String name;
  final String image;
  final List<Story> stories;

  Data({required this.name, required this.image, required this.stories});
}

class AppDataBase {
  static List<Data> data = [
    Data(
      name: 'Mitchell',
      image: 'assets/logo/Rectangle 10072 (1).png',
      stories: [
        Story(imageUrl: 'assets/logo/Rectangle 10072 (1).png', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    Data(
      name: 'User1ss',
      image: 'assets/logo/Rectangle 10072 (2).png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072 (3).png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072 (4).png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072 (5).png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072 (6).png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072 (7).png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072.png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
     Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072.png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
     Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072.png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),

     Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072.png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
     Data(
      name: 'User1',
      image: 'assets/logo/Rectangle 10072.png',
      stories: [
        Story(imageUrl: 'assets/logovoice1.jpg', userName: 'User1', duration: const Duration(seconds: 5)),

      ],
    ),
    // Add more users and their stories
  ];
}
