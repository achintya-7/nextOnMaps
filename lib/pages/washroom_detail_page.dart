import 'package:flutter/material.dart';
import 'package:nextonmaps/models/all_places.dart';

class WashroomDetailPage extends StatelessWidget {
  final Item washroom;

  const WashroomDetailPage(this.washroom, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/BG_washroom_detail.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text(washroom.name),
            backgroundColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey[200],
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Center(child: Text(washroom.name)),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                  color: Colors.black38,
                ),
                const SizedBox(height: 10),

                // * Address
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey[200],
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        washroom.address,
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                  color: Colors.black38,
                ),
                const SizedBox(height: 10),

                const Spacer(
                  flex: 2,
                ),

                SizedBox(
                  height: 45,
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Get Directions')),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  width: 180,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Review')),
                ),

                const Spacer()
              ],
            ),
          )),
    );
  }
}
