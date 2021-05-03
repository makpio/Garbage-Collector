import 'dart:io';
import 'package:flutter/foundation.dart';

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
  ) {
    final newItem = Item(id: id, image: image, name: name, location: null);
    _items.add(newItem);
    notifyListeners();
  }
}
