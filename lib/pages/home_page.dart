import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextonmaps/constants.dart';
import 'package:nextonmaps/pages/map_page.dart';
import 'package:nextonmaps/pages/signing_in.dart';
import 'package:nextonmaps/pages/washroom_page.dart';
import 'package:nextonmaps/widgets/drawer.dart';
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
          drawer: const Drawer(
            child: DrawerWidget(),
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
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WashRoomPage()));
                          },
                          child: Container()),
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
