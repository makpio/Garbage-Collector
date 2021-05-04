import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/screens/item_detail.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('items')
                      .where('user',
                          isEqualTo: FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.data == null)
                      return CircularProgressIndicator();
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (ctx, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot
                                    .data.docs[index]
                                    .data()['imageUrl']),
                              ),
                              title: Text(snapshot.data.docs[index]['name']),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItemDetail(
                                        item: snapshot.data.docs[index].data(),
                                      ),
                                    ));
                              },
                            ));
                  })),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add New Item'),
            onPressed: () {
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
