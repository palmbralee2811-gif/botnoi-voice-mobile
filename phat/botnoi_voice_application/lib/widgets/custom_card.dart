import 'package:flutter/material.dart';
class CustomCard extends StatelessWidget {
  final String id;
  final String name;
  final String country;
  final String sentences;

  const CustomCard({
    super.key,
    required this.id,
    required this.name,
    required this.country,
    required this.sentences
    });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.35,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // replace with actual image URL
                ),
                const SizedBox(width: 10),
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('ประเทศไทย', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.play_circle_fill),
                  onPressed: () {},
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'หนังทหารดุจุ้ง นุ้งเลอะหนังหมดลิงใหญ่ ยกลำโยเล็ก ลิงเล็ก ยกลำโยใหญ่ยายกินลำโยน้าลำยายใหลลอยd',
                    style: TextStyle(fontSize: 15,fontFamily: 'Prompt'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
                const SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}