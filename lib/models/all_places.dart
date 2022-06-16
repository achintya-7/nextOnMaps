// ignore_for_file: null_closures

import 'dart:convert';

class PlacesModel {
  static Item getById(int id) =>
      items.firstWhere((element) => element.id == id, orElse: null);
  static List<Item> items = [];
}

class ListModel {
  static List<Item> items = [];
}

class Item {
  final int id;
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;
  final String link;

  Item(
    this.id,
    this.name,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.link,
  );

  Item copyWith({
    int? id,
    String? name,
    String? phone,
    String? address,
    double? latitude,
    double? longitude,
    String? link,
  }) {
    return Item(
      id ?? this.id,
      name ?? this.name,
      phone ?? this.phone,
      address ?? this.address,
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      link ?? this.link,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'link': link,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        map['id']?.toInt() ?? 0,
        map['name'] ?? '',
        map['phone']?.toString() ?? '',
        map['address'] ?? '',
        map['latitude']?.toDouble() ?? 0.0,
        map['longitude']?.toDouble() ?? 0.0,
        map['link'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Item(id: $id, name: $name, phone: $phone, address: $address, latitude: $latitude, longitude: $longitude, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Item &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.link == link;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        link.hashCode;
  }
}
