import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:latlong/latlong.dart';

import '../models/item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items {
    return [..._items];
  }

  void addItem(
    String id,
    String name,
    File image,
    LatLng location,
  ) {
    final newItem = Item(
      id: id,
      image: image,
      name: name,
      location: location,
    );
    _items.add(newItem);
    notifyListeners();
  }
}
