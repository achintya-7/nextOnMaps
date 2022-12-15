import 'package:flutter/material.dart';
import 'package:nextonmaps/constants.dart';
import 'package:nextonmaps/pages/washroom_page.dart';
import 'package:nextonmaps/widgets/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Image image1;
  late Image image2;

  @override
  void initState() {
    super.initState();
    image1 = Image.asset("assets/images/background/BG_home_page.jpg");
    image2 = Image.asset("assets/images/background/BG_drawer.jpg");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    
  }

  @override
  Widget build(BuildContext context) {
    void _launchUrl(Uri uri) async {
      if (!await launchUrl(uri)) throw 'Could not launch $uri';
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image1.image,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: Drawer(
            child: DrawerWidget(
              image: image2,
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
