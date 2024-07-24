import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'Privacy Policy',
            style:
                GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
              print('Back');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/botnoivoice.png',
                      width: 54,
                      height: 62,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Privacy & policy',
                      style: GoogleFonts.prompt(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF323130)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    '· Privacy & policy',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Effective date: February 22, 2020\nBotnoi Consulting (“us”, “we”, or “our”) operates the https://botnoi.ai website (the “Service”).',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' We use your data to provide and improve the Service. By using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise defined in this Privacy Policy, terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, accessible from https://botnoi.ai',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Information Collection And Use',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'We collect several different types of information for various purposes to provide and improve our Service to you.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Types of Data Collected',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Personal Data',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '  While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you (“Personal Data”). Personally identifiable information may include, but is not limited to:\n  · First name and last name\n  · Cookies and Usage Data ',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Usage Data',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '  We may also collect information how the Service is accessed and used (“Usage Data”). This Usage Data may include information such as your computer’s Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers and other diagnostic data.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Tracking & Cookies Data',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'We use cookies and similar tracking technologies to track the activity on our Service and hold certain information.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' Cookies are files with small amount of data which may include an anonymous unique identifier. Cookies are sent to your browser from a website and stored on your device. Tracking technologies also used are beacons, tags, and scripts to collect and track information and to improve and analyze our Service.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Service. Examples of Cookies we use:\n · Session Cookies. We use Session Cookies to operate our Service.\n  · Preference Cookies. We use Preference Cookies to remember your preferences and various settings.\n  · Security Cookies. We use Security Cookies for security purposes. ',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Use of Data',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Botnoi Consulting uses the collected data for various purposes:\n· To provide and maintain the Service\n· To notify you about changes to our Service\n· To allow you to participate in interactive features of our Service when you choose to do so\n· To provide customer care and support\n· To provide analysis or valuable information so that we can improve the Service\n· To monitor the usage of the Service\n· To detect, prevent and address technical issues',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Transfer Of Data',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' Your information, including Personal Data, may be transferred to — and maintained on — computers located outside of your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from your jurisdiction.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' If you are located outside Thailand and choose to provide information to us, please note that we transfer the data, including Personal Data, to Thailand and process it there.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '  Your consent to this Privacy Policy followed by your submission of such information represents your agreement to that transfer.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' Botnoi Consulting will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy and no transfer of your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of your data and other personal information.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Disclosure Of Data',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Legal Requirements',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· To comply with a legal obligation\n· To protect and defend the rights or property of Botnoi Consulting\n· To prevent or investigate possible wrongdoing in connection with the Service\n· To protect the personal safety of users of the Service or the public\n· To protect against legal liability',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Security Of Data',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' The security of your data is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Service Providers',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '   We may employ third party companies and individuals to facilitate our Service (“Service Providers”), to provide the Service on our behalf, to perform Service-related services or to assist us in analyzing how our Service is used.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '  These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Links To Other Sites',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '   Our Service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party’s site. We strongly advise you to review the Privacy Policy of every site you visit.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '  We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Children’s Privacy',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'Our Service does not address anyone under the age of 18 (“Children”).',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    ' We do not knowingly collect personally identifiable information from anyone under the age of 18. If you are a parent or guardian and you are aware that your Children has provided us with Personal Data, please contact us. If we become aware that we have collected Personal Data from children without verification of parental consent, we take steps to remove that information from our servers.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    '· Changes To This Privacy Policy',
                    style: GoogleFonts.prompt(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    'We will let you know via email and/or a prominent notice on our Service, prior to the change becoming effective and update the “effective date” at the top of this Privacy Policy..',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      ' You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '· Changes To This Privacy Policy',
                      style: GoogleFonts.prompt(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      'If you have any questions about this Privacy Policy, please contact us:\n· By email: witv@botnoigroup.com',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      '',
                      style: GoogleFonts.prompt(
                          fontSize: 14, color: Color(0xFF605E5C)),
                    )),
              ],
            ),
          ),
        ));
  }
}
