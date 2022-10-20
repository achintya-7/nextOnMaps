import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nextonmaps/pages/detail_page.dart';
import 'package:nextonmaps/pages/signing_in.dart';
import 'package:nextonmaps/themes.dart';
import 'package:nextonmaps/widgets/item_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:nextonmaps/location_service.dart';
import 'package:nextonmaps/models/all_places.dart';

class MapSampleTwo extends StatefulWidget {
  const MapSampleTwo({Key? key}) : super(key: key);

  @override
  State<MapSampleTwo> createState() => MapSampleTwoState();
}

class MapSampleTwoState extends State<MapSampleTwo> {
  final Completer<GoogleMapController> _controller = Completer();

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};
  final Set<Marker> _locations = <Marker>{};

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  var directions;

  Item reference = Item(0, "", "0", "", 0, 0, "");

  bool isNumeric(String s) {
    if (int.tryParse(s) == null) {
      return false;
    }
    return true;
  }

  int _polylineCounter = 1;
  int _isLoading = -1;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    populateData();
    ListModel.items.clear();
    _locations.clear();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        // adUnitId: BannerAd.testAdUnitId,
        adUnitId: 'ca-app-pub-5074440068044295/7808930963',
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              print("Ad Loaded");
              _isAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            print('Some error : ' + error.toString());
          },
        ),
        request: const AdRequest());

    _bannerAd.load();
  }

  Future<void> addLocations() async {
    for (var itemL in _polylines.elementAt(0).points) {
      for (var itemM in _markers) {
        if (Geolocator.distanceBetween(itemL.latitude, itemL.longitude,
                itemM.position.latitude, itemM.position.longitude) <
            40000) {
          // earlier it was 20000
          _locations.add(itemM);
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
      _markers.add(Marker(markerId: const MarkerId('marker'), position: point));
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
        markerId: const MarkerId('temp_marker_1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(points[0].latitude, points[0].longitude),
        infoWindow: const InfoWindow(title: 'Start'),
      ));

      _markers.add(
        Marker(
            markerId: const MarkerId('temp_marker_2'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: end,
            infoWindow: const InfoWindow(title: 'Destination')),
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

  void _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) throw 'Could not launch $uri';
  }

  @override
  Widget build(BuildContext context) {
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
                    ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()));
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 1, 175, 210),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 210.0,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 14,
                            ),
                            TextFormField(
                              controller: _originController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                fillColor: Mytheme.darkcreamColor,
                                filled: true,
                                border: InputBorder.none,
                                hintText: "Origin",
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32),
                                    )),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32),
                                    )),
                              ),
                            ).pOnly(right: 24, left: 24),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              key: _formKey,
                              controller: _destinationController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                fillColor: Mytheme.darkcreamColor,
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                ),
                                filled: true,
                                border: InputBorder.none,
                                hintText: "Destination",
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32),
                                    )),
                                enabledBorder: const OutlineInputBorder(
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
                            ).pOnly(right: 24, left: 24),
                            const SizedBox(
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
                                      return states
                                              .contains(MaterialState.pressed)
                                          ? Colors.green
                                          : null;
                                    }),
                                    elevation: MaterialStateProperty.all(8),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(250, 50)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Mytheme.darkcreamColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            side: const BorderSide(
                                                color: Colors.white,
                                                width: 3)))),
                                onPressed: () async {
                                  if (_originController.text.isEmpty &&
                                      _destinationController.text.isEmpty) {
                                    const errorSnackBar = SnackBar(
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

                                    directions = await LocationService()
                                        .getDirections(_originController.text,
                                            _destinationController.text);

                                    _goToThePlace(
                                      directions['start_location']['lat'],
                                      directions['start_location']['lng'],
                                      directions['bounds_ne'],
                                      directions['bounds_sw'],
                                    );

                                    _setPolyline(
                                        directions['polyline_decoded'],
                                        LatLng(
                                            directions['end_location']['lat'],
                                            directions['end_location']['lng']));

                                    try {
                                      await addLocations();
                                      for (var item in _locations) {
                                        if (isNumeric(item.markerId.value)) {
                                          ListModel.items.add(
                                              PlacesModel.getById(int.parse(
                                                  item.markerId.value)));
                                        }
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Please first press search button")));
                                    }

                                    FocusScope.of(context).unfocus();

                                    setState(() {
                                      _isLoading = 0;
                                    });
                                  }
                                },
                                child: const Text(
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
              Container(height: 5, color: Colors.black),
              Expanded(
                  child: Container(
                // decoration: const BoxDecoration(
                //     // decoration: const BoxDecoration(
                //     //     image: DecorationImage(
                //     //         image: AssetImage("assets/images/mapBackground.jpeg"),
                //     //         fit: BoxFit.cover)),
                //     image: DecorationImage(
                //         image:
                //             AssetImage('assets/images/mapBackground.jpeg'),
                //         fit: BoxFit.cover)),
                child: ListModel.items.isNotEmpty
                    ? ListView.builder(
                        itemCount: ListModel.items.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: ItemWidget(item: ListModel.items[index]),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                        item: ListModel.items[index],
                                      )));
                            },
                          );
                        },
                      )
                    : _isLoading == 1
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                          ),
              ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isAdLoaded
          ? SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : const SizedBox(),
    );
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
