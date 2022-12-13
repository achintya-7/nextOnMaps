import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nextonmaps/pages/washroom_list.dart';
import 'package:nextonmaps/widgets/sundar_card.dart';

class WashRoomPage extends StatelessWidget {
  const WashRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController originController = TextEditingController();
    TextEditingController destinationController = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/BG_washroom_page.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,

          // * App bar
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text('Welcome'),
          ),

          // * Body
          body: Column(
            children: [
              // * Heading
              const SizedBox(height: 30),
              const Text(
                "Looking for clean",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SundarCard(
                  radius: 10,
                  widget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        Icons.man,
                        size: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: VerticalDivider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "Washrooms",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: VerticalDivider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Icon(Icons.woman, size: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "on your way?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              const SizedBox(height: 50),

              // * TextFiellds
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                child: TextField(
                  controller: originController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Origin",
                    suffixIcon: IconButton(
                        onPressed: () => originController.clear(),
                        icon: const Icon(Icons.clear)),
                    prefixIcon: const Icon(Icons.location_on),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                child: TextField(
                  controller: destinationController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.location_on),
                    suffixIcon: IconButton(
                        onPressed: () => originController.clear(),
                        icon: const Icon(Icons.clear)),
                    hintText: "Destination",
                    filled: true,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),

              // * Button
              const SizedBox(height: 50),

              SizedBox(
                  width: 180,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        if (originController.text.isEmpty) {
                          Fluttertoast.showToast(msg: "Please fill Origin");
                          return;
                        }
                        if (destinationController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please fill Destination");
                          return;
                        }

                        // * Navigate to next page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WashRoomListPage(
                                origin: originController.text,
                                destination: destinationController.text)));
                      },
                      child: const Text("Search",
                          style: TextStyle(fontSize: 20)))),
            ],
          )),
    );
  }
}
