import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garbage_collector/screens/authenticate/authenticate.dart';
import 'package:garbage_collector/screens/map_screen.dart';

import './screens/user_items_list.dart';
import './screens/wrapper.dart';
import './screens/add_item.dart';

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
        Authenticate.routeName: (_) => Authenticate(),
        UserItemsList.routeName: (_) => UserItemsList(),
        AddItem.routeName: (_) => AddItem(),
        MapScreen.routeName: (_) => MapScreen(),
      },
    );
  }
}
