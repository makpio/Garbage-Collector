import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/widgets/location_input.dart';
import '../widgets/image_input.dart';
import 'package:path/path.dart' as path;
import 'package:latlong/latlong.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditItemScreen extends StatefulWidget {
  //static const routeName = '/edit-item';

  final item;
  EditItemScreen({Key key, @required this.item}) : super(key: key);

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Image _initImage;
  LatLng _initLocation;
  File _selectedImage;
  LatLng _selectedLocation;

  @override
  void initState() {
    if (widget.item['name'] != null) {
      _nameController.text = widget.item['name'];
    }
    if (widget.item['description'] != null) {
      _descriptionController.text = widget.item['description'];
    }
    if (widget.item['imageUrl'] != null) {
      _initImage = Image.network(
        widget.item['imageUrl'],
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    if (widget.item['location.lat'] != null &&
        widget.item['location.lng'] != null) {
      _initLocation =
          new LatLng(widget.item['location.lat'], widget.item['location.lng']);
    }
    super.initState();
  }

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  void _selectLocation(LatLng selectedLocation) {
    _selectedLocation = selectedLocation;
  }

  void _saveitem() async {
    if (this._nameController.text.isEmpty || _selectedImage == null) {
      return;
    }
    try {
      String fileName = path.basename(_selectedImage.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_selectedImage);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = (await taskSnapshot.ref.getDownloadURL()).toString();
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('items').add({
        'user': FirebaseAuth.instance.currentUser.uid,
        'name': _nameController.text,
        'imageUrl': downloadUrl,
        'location.lat': _selectedLocation.latitude,
        'location.lng': _selectedLocation.longitude,
      });

      Navigator.of(context).pop();
    } catch (err) {
      var message = 'An error occured during adding new item';

      if (err.message != null) {
        message = err.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit ' + widget.item['name'],
          textAlign: TextAlign.center,
        ),
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
                    controller: _nameController,
                    onChanged: (text) => {},
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Item Name",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Item Name",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage, _initImage),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(_selectLocation, _initLocation),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Save Item'),
            onPressed: _saveitem,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              elevation: 10,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
