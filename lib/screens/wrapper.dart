import 'package:flutter/material.dart';
import 'package:garbage_collector/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // return either Home or Authenticate widget
    return Home();
  }
}