import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nextonmaps/location_service.dart';
import 'package:nextonmaps/models/all_places.dart';

class MapService {

  // * This function is the driver function for the whole process. Call this function to get the list of recommended locations
  static Future<List<Marker>> driverFunc(
      String origin, String destination) async {
    List<PointLatLng> pointsOfPolyline = await getPolyLine(origin, destination);
    List<Marker> allLocations = await populateData();
    return getRecommendations(pointsOfPolyline, allLocations);
  }

  // * This function returns the list of recommended locations based on the polyline points and the list of all locations
  static List<Marker> getRecommendations(
      List<PointLatLng> pointsOfPolyline, List<Marker> allLocations) {
    Set<Marker> recommendedLocations = {};

    for (var i = 0; i < pointsOfPolyline.length; i = i + 5) {
      for (var j = 0; j < allLocations.length; j++) {
        // * If the distance between the polyline point and the marker is less than 40km, add it in the set
        if (Geolocator.distanceBetween(
                pointsOfPolyline[i].latitude,
                pointsOfPolyline[i].longitude,
                allLocations.elementAt(j).position.latitude,
                allLocations.elementAt(j).position.longitude) <
            40000) {
          recommendedLocations.add(allLocations.elementAt(j));
        }
      }
    }
    return recommendedLocations.toList();
  }

  // * This function returns the list of all the markers from the json file
  static Future<List<Marker>> populateData() async {
    List<Marker> _markers = [];

    var placesJson = await rootBundle.loadString("assets/files/JsonData.json");
    var decodeData = jsonDecode(placesJson);
    var placesData = decodeData['places'];

    PlacesModel.items =
        List.from(placesData).map((item) => Item.fromMap(item)).toList();

    for (var item in PlacesModel.items) {
      _markers.add(Marker(
        markerId: MarkerId(item.id.toString()),
        position: LatLng(item.latitude, item.longitude),
        infoWindow: InfoWindow(title: item.name, snippet: item.phone),
      ));
    }

    return _markers;
  }

  // * This function returns the list of polyline points from the origin to the destination using the Google Directions API
  static Future<List<PointLatLng>> getPolyLine(
      String origin, String destination) async {
    var directions = await LocationService().getDirections(origin, destination);
    List<PointLatLng> list =
        directions['polyline_decoded'] as List<PointLatLng>;
    return list;
  }
}
