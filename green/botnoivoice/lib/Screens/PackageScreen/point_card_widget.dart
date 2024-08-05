import 'package:botnoivoice/Screens/PackageScreen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PointCardWidget extends StatefulWidget {
  const PointCardWidget({super.key});

  @override
  _PointCardWidgetState createState() => _PointCardWidgetState();
}

class _PointCardWidgetState extends State<PointCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: const EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: const Text(
                    'Your Point',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      const Image(image: AssetImage('assets/images/point.png')),
                      const SizedBox(width: 4),
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
                      GradientTextPackageScreen(
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
                      const SizedBox(height: 8),
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
                    style: const TextStyle(color: Colors.blue),
                  ),
                )
              : Text(value),
        ],
      ),
    );
  }
}
