// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nextonmaps/models/all_places.dart';
import 'package:nextonmaps/services/map_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> startLocation;
  final Item item;

  const DetailsPage({Key? key, required this.item, required this.startLocation})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    GoogleMapController? _googleMapController;
    LatLng _center = LatLng(widget.item.latitude, widget.item.longitude);
    List<Marker> _markers = [
      Marker(
          markerId: const MarkerId('Start'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position:
              LatLng(widget.startLocation['lat'], widget.startLocation['lng']),
          infoWindow: const InfoWindow(title: 'Start')),
      Marker(
          markerId: const MarkerId('Start'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(widget.item.latitude, widget.item.longitude),
          infoWindow:
              InfoWindow(title: widget.item.name, snippet: widget.item.address))
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Details',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = _googleMapController;
              },
              markers: _markers.toSet(),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 7.0,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    color: Colors.black,
                  ).p(8),
                  Text(
                    widget.item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ).p(8),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ).p(8),
                  Text(widget.item.address,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))
                      .p(8),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ).p(8),
                ],
              ).centered(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          enableFeedback: true,
                          overlayColor:
                              MaterialStateProperty.resolveWith((states) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.grey
                                : null;
                          }),
                          elevation: MaterialStateProperty.all(8),
                          fixedSize:
                              MaterialStateProperty.all(const Size(250, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: const BorderSide(
                                          color: Colors.black, width: 3)))),
                      onPressed: () async {
                        const urlOpen = "https://g.co/kgs/8v65s1";
                        try {
                          if (await canLaunch(widget.item.link)) {
                            await launch(
                              widget.item.link,
                              forceWebView: false,
                              enableJavaScript: true,
                            );
                          }
                        } catch (e) {
                          print("Error : " + e.toString());
                        }
                        print(widget.item.link);
                      },
                      child: const Text(
                        "Get Directions",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          enableFeedback: true,
                          overlayColor:
                              MaterialStateProperty.resolveWith((states) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.grey
                                : null;
                          }),
                          elevation: MaterialStateProperty.all(8),
                          fixedSize:
                              MaterialStateProperty.all(const Size(250, 50)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: const BorderSide(
                                          color: Colors.black, width: 3)))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Go Back",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ).pOnly(bottom: 20)
          ],
        ));
  }
}
