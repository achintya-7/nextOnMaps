import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextonmaps/pages/map_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    void _launchUrl(Uri uri) async {
      if (!await launchUrl(uri)) throw 'Could not launch $uri';
    }

    return Scaffold(
        drawer: SafeArea(
          child: Drawer(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3)),
                child: Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      const Text(
                        'Contact Us',
                        style:
                            TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Spacer(flex: 3),
                          IconButton(
                              onPressed: () {
                                Uri uri = Uri.parse(
                                    'https://www.instagram.com/nextonmap/');
                                _launchUrl(uri);
                              },
                              icon: const FaIcon(FontAwesomeIcons.instagram,
                                  size: 45)),
                          const Spacer(flex: 1),
                          IconButton(
                              onPressed: () {
                                Uri uri = Uri.parse(
                                    'https://www.facebook.com/nextonmap-100479358427034/?ref=pages_you_manage');
                                _launchUrl(uri);
                              },
                              icon: const FaIcon(FontAwesomeIcons.facebook,
                                  size: 45)),
                          const Spacer(flex: 1),
                          IconButton(
                              onPressed: () {
                                Uri uri = Uri.parse(
                                    'https://www.youtube.com/channel/UCF8Yg_x_OL3tvf2KnUzHhbA');
                                _launchUrl(uri);
                              },
                              icon: const FaIcon(FontAwesomeIcons.youtube,
                                  size: 45)),
                          const Spacer(flex: 3),
                        ],
                      ).centered(),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Uri uri = Uri.parse('https://sites.google.com/view/nextonmap-privacypolicy/home');
                          _launchUrl(uri);
                        },
                        child: const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color.fromARGB(255, 8, 89, 230),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Welcome",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black,
        ),
        body: const HeightLarge());
  }
}

class HeightLarge extends StatelessWidget {
  const HeightLarge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(width: 2)),
            child: const Text(
              'NEXT STOPS',
              style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ).pOnly(left: 12, right: 12, top: 6, bottom: 6),
          ).pOnly(left: 24, right: 24, top: 24, bottom: 12),
          const Text(
            ' By ',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),
          ),
          const Text(
            ' Next On Map ',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),
          ),
          const Spacer(flex: 1),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.orangeAccent)),
            child: const Text(
              'Looking for clean \n washrooms on \n your way?',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ).pOnly(left: 12, right: 12, top: 6, bottom: 6),
          ).pOnly(left: 2, right: 2, top: 12, bottom: 12),
          const Spacer(flex: 1),
          ElevatedButton(
            style: ButtonStyle(
                enableFeedback: true,
                elevation: MaterialStateProperty.all(8),
                overlayColor: MaterialStateProperty.resolveWith((states) {
                  return states.contains(MaterialState.pressed)
                      ? Colors.grey
                      : null;
                }),
                fixedSize: MaterialStateProperty.all(const Size(280, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  //side: const BorderSide(color: Colors.black, width: 3)
                ))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const MapSampleTwo()));
            },
            child: const Text(
              "Click Here",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
