import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/widgets/location_input.dart';
import '../widgets/image_input.dart';
import 'package:path/path.dart' as path;
import 'package:latlong/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditUserScreen extends StatefulWidget {
  final user;
  final userId;

  EditUserScreen({
    Key key,
    @required this.user,
    @required this.userId,
  }) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  Image _initImage;
  File _selectedImage;

  @override
  void initState() {
    if (widget.user['username'] != null) {
      _nameController.text = widget.user['username'];
    }
    if (widget.user['email'] != null) {
      _emailController.text = widget.user['email'];
    }
    if (widget.user['phoneNo'] != null) {
      _phoneController.text = widget.user['phoneNo'];
    }
    if (widget.user['imageUrl'] != null) {
      _initImage = Image.network(
        widget.user['imageUrl'],
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    super.initState();
  }

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  void _editUser() async {
    // if (this._nameController.text.isEmpty) {
    //   return;
    // }

    String downloadUrl;
    if (_selectedImage != null) {
      String fileName = path.basename(_selectedImage.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_selectedImage);
      TaskSnapshot taskSnapshot = await uploadTask;
      downloadUrl = (await taskSnapshot.ref.getDownloadURL()).toString();
    } else {
      downloadUrl = widget.user['imageUrl'];
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'username': _nameController.text,
        'email': _emailController.text,
        'phoneNo': _phoneController.text,
        'imageUrl': downloadUrl,
      });

      var firebaseUser = FirebaseAuth.instance.currentUser;
      firebaseUser
          .updateEmail(_emailController.text)
          .then((val) {})
          .catchError((err) {
        // An error has occured.
      });

      firebaseUser.updatePassword('test6969').then((val) {}).catchError((err) {
        // An error has occured.
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (err) {
      var message = 'An error occured during editing user profile';

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
          'Edit profile',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                print(widget.userId);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId)
                    .delete()
                    .then((value) => Navigator.pop(context))
                    .then((value) => Navigator.pop(context))
                    .then((value) {
                      var firebaseUser = FirebaseAuth.instance.currentUser;
                      firebaseUser.delete();
                    })
                    .then((value) => FirebaseAuth.instance.signOut())
                    .catchError(
                        (error) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: Theme.of(context).errorColor,
                              ),
                            ));
              }),
        ],
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
                  ImageInput(_selectImage, _initImage),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Name",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Name",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _emailController,
                    onChanged: (text) => {},
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "E-mail",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "E-mail",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Phone",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Phone",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Save Profile'),
            onPressed: _editUser,
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
