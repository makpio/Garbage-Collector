import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import './add_item.dart';

class UserItemsList extends StatefulWidget {
  static const routeName = '/user-items-list';

  @override
  _UserItemsListState createState() => _UserItemsListState();
}

class _UserItemsListState extends State<UserItemsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Item'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) => new AddItem()));
              Navigator.of(context).pushNamed(AddItem.routeName);
            },
          ),
        ],
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
