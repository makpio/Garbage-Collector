import 'package:flutter/foundation.dart';

import '../models/item.dart';

class Items with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items {
    return [..._items];
  }
}