import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/screens/item_detail.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './add_item.dart';
import '../providers/items.dart';

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
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Consumer<Items>(
              child: Center(
                child: const Text('You have no items yet'),
              ),
              builder: (ctx, items, ch) => items.items.length <= 0
                  ? ch
                  : ListView.builder(
                      itemCount: items.items.length,
                      itemBuilder: (ctx, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(items.items[index].image),
                            ),
                            title: Text(items.items[index].name),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetail(
                                      item: items.items[index],
                                    ),
                                  ));
                            },
                          )),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add New Item'),
            onPressed: () {
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) => new AddItem()));
              Navigator.of(context).pushNamed(AddItem.routeName);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              elevation: 10,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
