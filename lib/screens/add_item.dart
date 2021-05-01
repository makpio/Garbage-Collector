import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../widgets/image_input.dart';

import '../providers/items.dart';

class AddItem extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _nameController = TextEditingController();
  File _selectedImage;

  void _selectImage(File selectedImage) {
    _selectedImage = selectedImage;
  }

  void _saveitem() {
    if (_nameController.text.isEmpty || _selectedImage == null) {
      return;
    }
    Provider.of<Items>(context, listen: false)
        .addItem(_nameController.text, _selectedImage);
    Navigator.of(context).pop();
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
                  TextField(
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(_selectImage),
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
