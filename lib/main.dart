import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garbage_collector/screens/auth_screen.dart';
import 'package:garbage_collector/screens/edit_item_screen.dart';
import 'package:garbage_collector/screens/map_screen.dart';
import 'package:garbage_collector/screens/start_screen.dart';

import 'screens/my_items_screen.dart';
import 'wrapper.dart';
import 'screens/add_item_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Garbage Collector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue,
      ),
      home: Wrapper(),
      routes: {
        AuthScreen.routeName: (_) => AuthScreen(),
        MyItemsScreen.routeName: (_) => MyItemsScreen(),
        AddItemScreen.routeName: (_) => AddItemScreen(),
        MapScreen.routeName: (_) => MapScreen(),
        StartScreen.routeName: (_) => StartScreen(),
      },
    );
  }
}
