import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricepackage/package.dart';

class Pointcard extends StatefulWidget {
  @override
  _PointcardState createState() => _PointcardState();
}

class _PointcardState extends State<Pointcard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    'Your Point',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Image(image: AssetImage('assets/images/point4.png')),
                      SizedBox(width: 4),
                      Text(
                        '100 ',
                        style: GoogleFonts.prompt(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
              body: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientText(
                        'Main Package',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        style: GoogleFonts.prompt(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInfoRow('Membership', 'General'),
                      _buildInfoRow('Package', 'Free', linkText: 'Free'),
                      _buildInfoRow('แพ็คเสริม', 'No Ads', linkText: 'No Ads'),
                      _buildInfoRow('Expire', '-'),
                      _buildInfoRow('Auto-renewal', 'Disabled'),
                    ],
                  ),
                ),
              ),
              isExpanded: _isExpanded,
              canTapOnHeader: true,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {String? linkText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          linkText != null
              ? InkWell(
                  onTap: () {},
                  child: Text(
                    linkText,
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              : Text(value),
        ],
      ),
    );
  }
}
