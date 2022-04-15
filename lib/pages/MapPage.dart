// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_collection_literals, unnecessary_new, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nextonmaps/pages/DetailsPage.dart';
import 'package:nextonmaps/themes.dart';
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
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background_1.jpg"),
                      fit: BoxFit.cover
                  )
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 14,
                                  ),
                                  TextFormField(
                                    controller: _originController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        color: Colors.white54
                                      ),
                                      fillColor: Mytheme.darkcreamColor,
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: "Origin",
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32),
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32),
                                          )),
                                    ),
                                  ).pOnly(right: 24, left: 24),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    key: _formKey,
                                    controller: _destinationController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      fillColor: Mytheme.darkcreamColor,
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      filled: true,
                                      border: InputBorder.none,
                                      hintText: "Destination",
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32),
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32),
                                          )),
                                    ),
                                    validator: (title) =>
                                        title != null && title.isEmpty
                                            ? 'Cannot be empty'
                                            : null,
                                  ).pOnly(right: 24 ,left: 24),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: Colors.transparent,
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
                                                  Mytheme.darkcreamColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                  side: const BorderSide(
                                                      color: Colors.white,
                                                      width: 2)))),
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
                                            color: Colors.white,
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
                    Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent
                          ),
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
                                        color: Colors.transparent
                                      ),
                                    ),
                    ))
                  ],
                ),
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
