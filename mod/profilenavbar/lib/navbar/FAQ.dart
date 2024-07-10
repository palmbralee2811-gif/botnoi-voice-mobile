import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  final List<Item> _data = generateItems(5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'FAQ',
            style: GoogleFonts.prompt(fontSize: 16, color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              print('Back');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: _buildPanel(),
        ));
  }

  Widget _buildPanel() {
    return Container(
      color: Colors.white,
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = isExpanded;
          });
        },
        children: _data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            backgroundColor: Colors.white,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    item.headerValue,
                    style: GoogleFonts.prompt(fontSize: 14),
                  ),
                ),
              );
            },
            body: Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  item.expandedValue,
                  style: GoogleFonts.prompt(fontSize: 14),
                ),
                subtitle: const Text(''),
              ),
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return [
    Item(
      headerValue: 'What is text to speech (TTS)?',
      expandedValue:
          'Text to Speech (TTS) is a technology that can generate spoken words from any text as needed. Botnoi Voice is a service provider that supports a wide variety of voices, offering more than 100 different options.',
    ),
    Item(
      headerValue: 'How to convert text to speech?',
      expandedValue:
          'Botnoi Voice is the simplest way to convert text into speech. Simply type the text to be spoken or read aloud, and then select your voiceover from the available languages or categories. After customization and generation, it is now available for download and sharing.',
    ),
    Item(
      headerValue: 'Do i have to subscribe to a plan?',
      expandedValue:
          "There's no need to. Botnoi voice allows you to choose and pay for only the features and services that meet your needs.",
    ),
    Item(
      headerValue: 'Do you have an API for Developer?',
      expandedValue:
          'We offer an API service that supports various programming languages, complete with usage examples. Whether you use Golang, Python, or NodeJS, you can integrate it into your website or application immediately.',
    ),
    Item(
      headerValue: 'Can I try out Botnoi Voice for free?',
      expandedValue:
          'New users can immediately create voices for free upon signing up for a Botnoi Voice account. This allows you to immerse yourself in and explore the creation of diverse voices for your creative projects and business needs.',
    ),
  ];
}
