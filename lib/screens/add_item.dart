import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/widgets/location_input.dart';
import 'package:provider/provider.dart';
import '../widgets/image_input.dart';
import 'package:path/path.dart' as path;
import 'package:latlong/latlong.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../providers/items.dart';

class AddItem extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File _selectedImage;
  LatLng _selectedLocation;

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  void _selectLocation(LatLng selectedLocation) {
    _selectedLocation = selectedLocation;
  }

  void _saveitem() async {
    if (_nameController.text.isEmpty || _selectedImage == null) {
      return;
    }
    try {
      String fileName = path.basename(_selectedImage.path);
      firebase_storage.Reference firebaseStorageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('uploads/$fileName');
      firebase_storage.UploadTask uploadTask =
          firebaseStorageRef.putFile(_selectedImage);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = (await taskSnapshot.ref.getDownloadURL()).toString();
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('items').add({
        'user': FirebaseAuth.instance.currentUser.uid,
        'name': _nameController.text,
        'imageUrl': downloadUrl,
        'location.lat': _selectedLocation.latitude,
        'location.lng': _selectedLocation.longitude,
      });

      print('xd');
      print(_selectedLocation);
      //temporary part, for local
      Provider.of<Items>(context, listen: false).addItem(
          docRef.id, _nameController.text, _selectedImage, _selectedLocation);

      Navigator.of(context).pop();
    } catch (err) {
      var message = 'An error occured during adding new item';

      if (err.message != null) {
        message = err.message;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new item'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Item Name",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(), // <-- This is the key
                      labelText: "Item Name",
                    ),
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(), // <-- This is the key
                      labelText: "Description",
                    ),
                    controller: _descriptionController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_selectLocation),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Item'),
            onPressed: _saveitem,
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              elevation: 10,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
        ],
      ),
    );
  }
}
