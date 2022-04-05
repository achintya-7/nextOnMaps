// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_collection_literals, unnecessary_new, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nextonmaps/pages/DetailsPage.dart';
import 'package:nextonmaps/widgets/item_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:nextonmaps/location_service.dart';
import 'package:nextonmaps/models/allPlaces.dart';

class MapSampleTwo extends StatefulWidget {
  const MapSampleTwo({Key? key}) : super(key: key);

  @override
  State<MapSampleTwo> createState() => MapSampleTwoState();
}

class MapSampleTwoState extends State<MapSampleTwo> {
  Completer<GoogleMapController> _controller = Completer();

  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Marker> _locations = Set<Marker>();

  Item reference = Item(0, "", "0", "", 0, 0, "");

  bool isNumeric(String s) {
    if (int.tryParse(s) == null) {
      return false;
    }
    return true;
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 14.4746,
  );

  int _polylineCounter = 1;
  int _isLoading = -1;

  @override
  void initState() {
    super.initState();
    populateData();
    ListModel.items.clear();
    _locations.clear();
  }

  Future<void> addLocations() async {
    for (var item_l in _polylines.elementAt(0).points) {
      for (var item_m in _markers) {
        if (Geolocator.distanceBetween(item_l.latitude, item_l.longitude,
                item_m.position.latitude, item_m.position.longitude) <
            50000) {
          _locations.add(item_m);
        }
      }
    }
  }

  populateData() async {
    // await loadData();
    var placesJson = await rootBundle.loadString("assets/files/JsonData.json");
    var decodeData = jsonDecode(placesJson);
    var placesData = decodeData['places'];

    PlacesModel.items =
        List.from(placesData).map((item) => Item.fromMap(item)).toList();

    for (var item in PlacesModel.items) {
      _markers.add(Marker(
          markerId: MarkerId(item.id.toString()),
          position: LatLng(item.latitude, item.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          infoWindow: InfoWindow(title: item.name, snippet: item.phone),
          onTap: () {
            setState(() {
              reference = item;
            });
          }));
    }

    setState(() {});
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(markerId: MarkerId('marker'), position: point));
    });
  }

  void _setPolyline(List<PointLatLng> points, LatLng end) {
    final String polylineIdVal = 'polyline_$_polylineCounter';
    _polylineCounter++;
    _polylines.clear();

    try {
      _markers.remove('temp_marker_1');
      _markers.remove('temp_marker_2');
    } finally {
      _markers.add(Marker(
        markerId: MarkerId('temp_marker_1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(points[0].latitude, points[0].longitude),
        infoWindow: InfoWindow(title: 'Start'),
      ));

      _markers.add(
        Marker(
            markerId: MarkerId('temp_marker_2'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: end,
            infoWindow: InfoWindow(title: 'Destination')),
      );
    }

    _polylines.add(Polyline(
      polylineId: PolylineId(polylineIdVal),
      width: 12,
      color: Colors.blue,
      points: points
          .map(
            (point) => LatLng(point.latitude, point.longitude),
          )
          .toList(),
    ));

    setState(() {});
    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                "Map Page",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          image: DecorationImage(
                              image: AssetImage("assets/images/Travel.jpg"),
                              fit: BoxFit.cover)),
                      child: SizedBox(
                        height: 200,
                        width: 400,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    controller: _originController,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: InputBorder.none,
                                        hintText: "Origin",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3, color: Colors.black),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(32),
                                                bottomRight:
                                                    Radius.circular(32))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3, color: Colors.black),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(32),
                                                bottomRight:
                                                    Radius.circular(32)))),
                                  ).pOnly(right: 64),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: _formKey,
                                    controller: _destinationController,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: InputBorder.none,
                                        hintText: "Destination",
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3, color: Colors.black),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(32),
                                                bottomLeft:
                                                    Radius.circular(32))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 3, color: Colors.black),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(32),
                                                bottomLeft:
                                                    Radius.circular(32)))),
                                    validator: (title) =>
                                        title != null && title.isEmpty
                                            ? 'Cannot be empty'
                                            : null,
                                  ).pOnly(left: 64),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          enableFeedback: true,
                                          overlayColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            return states.contains(
                                                    MaterialState.pressed)
                                                ? Colors.grey
                                                : null;
                                          }),
                                          elevation:
                                              MaterialStateProperty.all(8),
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(250, 50)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                  side: const BorderSide(
                                                      color: Colors.black,
                                                      width: 3)))),
                                      onPressed: () async {
                                        if (_originController.text.isEmpty &&
                                            _destinationController
                                                .text.isEmpty) {
                                          final errorSnackBar = SnackBar(
                                              content: Text(
                                                  "Please mention the locations"));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(errorSnackBar);
                                        } else {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();

                                          setState(() {
                                            _isLoading = 1;
                                          });

                                          if (_locations.isNotEmpty) {
                                            ListModel.items.clear();
                                            _locations.clear();
                                          }

                                          var directions =
                                              await LocationService()
                                                  .getDirections(
                                                      _originController.text,
                                                      _destinationController
                                                          .text);

                                          _goToThePlace(
                                            directions['start_location']['lat'],
                                            directions['start_location']['lng'],
                                            directions['bounds_ne'],
                                            directions['bounds_sw'],
                                          );

                                          _setPolyline(
                                              directions['polyline_decoded'],
                                              LatLng(
                                                  directions['end_location']
                                                      ['lat'],
                                                  directions['end_location']
                                                      ['lng']));

                                          try {
                                            await addLocations();
                                            for (var item in _locations) {
                                              if (isNumeric(
                                                  item.markerId.value)) {
                                                ListModel.items.add(PlacesModel
                                                    .getById(int.parse(
                                                        item.markerId.value)));
                                              }
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Please first press search button")));
                                          }
                                          
                                          FocusScope.of(context).unfocus();

                                          setState(() {
                                            _isLoading = 0;
                                          });
                                        }
                                      },
                                      child: Text(
                                        "Search",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    child: ListModel.items.isNotEmpty
                        ? ListView.builder(
                            itemCount: ListModel.items.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ItemWidget(item: ListModel.items[index]),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                          item: ListModel.items[index])));
                                },
                              );
                            },
                          )
                        : _isLoading == 1
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 3),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/indiaHigh.png"),
                                        fit: BoxFit.cover)),
                              ),
                  ))
                ],
              ),
            )));
  }

  Future<void> _goToThePlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, lng),
        zoom: 12,
      )),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );
    _setMarker(LatLng(lat, lng));
  }
}
