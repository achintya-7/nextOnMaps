import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nextonmaps/models/all_places.dart';
import 'package:nextonmaps/my_services/map_service.dart';
import 'package:nextonmaps/pages/washroom_detail_page.dart';

class WashRoomListPage extends StatelessWidget {
  const WashRoomListPage(
      {super.key, required this.origin, required this.destination});
  final String origin;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background/BG_washroom_list.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        // * App bar
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Next Stops'),
        ),

        // * Body
        body: Column(
          children: [
            // * Heading of Destinations
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Card(
                    color: Colors.lightBlue[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: 50,
                      width: 110,
                      child: Center(child: Text(origin)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.lightGreen[100],
                    child: SizedBox(
                      height: 50,
                      width: 110,
                      child: Center(child: Text(destination)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // * List of washrooms
            Expanded(
              child: FutureBuilder<List<Marker>>(
                  future: MapService.driverFunc(origin, destination),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Error: Something went wrong, \nPlease try again later',
                            ),
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      List<Marker> markers = snapshot.data;

                      if (markers.isEmpty) {
                        return const Center(
                          child: Card(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("No Washrooms Found, \nSorry!"),
                          )),
                        );
                      }

                      return ListView.builder(
                        itemCount: markers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 2),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white70,
                              elevation: 20,
                              shadowColor: Colors.black,
                              child: ListTile(
                                title: Text(
                                  markers[index].infoWindow.title!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  markers[index].infoWindow.snippet!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Item item = PlacesModel.getById(
                                      int.parse(markers[index].markerId.value));
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) =>
                                          WashroomDetailPage(item)));
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
