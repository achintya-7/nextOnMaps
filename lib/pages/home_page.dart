import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextonmaps/constants.dart';
import 'package:nextonmaps/pages/map_page.dart';
import 'package:nextonmaps/pages/signing_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _launchUrl(Uri uri) async {
      if (!await launchUrl(uri)) throw 'Could not launch $uri';
    }

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/BG_home_page.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
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
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
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
                        ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInPage()));
                            },
                            child: const Text('Sign Out')),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Uri uri = Uri.parse(
                                'https://sites.google.com/view/nextonmap-privacypolicy/home');
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
            title: const Text("Next On Map",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.black,
          ),
          body: const HeightLarge()),
    );
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
          const SizedBox(height: 20),
          const Text(
            'Travel Away',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const Text(
            'The Easy Way...',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridTile(
                    footer: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 16.0),
                      child: Center(child: Text(mapCategories[index])),
                    ),
                    child: Card(
                      color: Colors.blue[100],
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(onTap: () {}, child: Container()),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
