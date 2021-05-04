import 'dart:io';
import 'package:latlong/latlong.dart';
import 'package:flutter/foundation.dart';

// class ItemLocation {
//   final double latitude;
//   final double longitude;
//   final String address;

//   ItemLocation({
//     @required this.latitude,
//     @required this.longitude,
//     this.address,
//   });
// }

class Item {
  final String id;
  final String name;
  final LatLng location;
  final File image;

  Item({
    @required this.id,
    @required this.name,
    @required this.location,
    @required this.image,
  });
}
