import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/image_input.dart';
import 'package:path/path.dart' as path;
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

  _showDeleteAlert(BuildContext context) {
    AlertDialog deleteAlert = AlertDialog(
      title: Text("Are you sure you want to delete this user?"),
      actions: [
        ElevatedButton.icon(
          icon: Icon(Icons.delete),
          label: Text("Delete"),
          onPressed: () async {
            _deleteUser();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            elevation: 10,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.cancel),
          label: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return deleteAlert;
      },
    );
  }

  void _deleteUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .delete()
        .then((value) => Navigator.pop(context))
        .then((value) => Navigator.pop(context))
        .then((value) => Navigator.pop(context))
        .then((value) {
          var firebaseUser = FirebaseAuth.instance.currentUser;
          firebaseUser.delete();
        })
        .then((value) => FirebaseAuth.instance.signOut())
        .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Theme.of(context).errorColor,
              ),
            ));
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(text),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _editUser() async {
    bool isSuccess;
    if (this._nameController.text.isEmpty) {
      _showToast(context, 'User name cannot be empty!');
      return;
    }

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

    if (_emailController.text != widget.user['email']) {
      var firebaseUser = FirebaseAuth.instance.currentUser;
      await firebaseUser.updateEmail(_emailController.text).then((val) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'email': _emailController.text,
        });
      }).catchError((err) async {
        var message = 'An error occured during editing user email';
        print(err.message);
        if (err.message != null) {
          message = err.message;
        }

        isSuccess = false;
        print('xd1');
        _showToast(context, message);
        return;
      });
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .update({
      'username': _nameController.text,
      'phoneNo': _phoneController.text,
      'imageUrl': downloadUrl,
    }).catchError((err) async {
      var message = 'An error occured during updating user profile';
      print(err.message);
      if (err.message != null) {
        message = err.message;
      }
      isSuccess = false;
      _showToast(context, message);
      return;
    });

    if (isSuccess != false) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
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
                _showDeleteAlert(context);
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Save Profile'),
              onPressed: _editUser,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                elevation: 10,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
