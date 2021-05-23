import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/screens/item_detail_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'add_item_screen.dart';

class StarredItemsScreen extends StatefulWidget {
  static const routeName = '/starred-items-list';

  @override
  _StarredItemsScreenState createState() => _StarredItemsScreenState();
}

class _StarredItemsScreenState extends State<StarredItemsScreen> {
  var starredItems = [];

  _getStarredItems() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((user) {
      setState(() {
        starredItems = user.data()['starredItems'] ?? [];
      });
    });
  }

  @override
  void initState() {
    _getStarredItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _getStarredItems();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Starred Items',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: StreamBuilder(
                  stream: starredItems.length > 0
                      ? (FirebaseFirestore.instance.collection('items').where(
                              FieldPath.documentId,
                              whereIn: starredItems))
                          .snapshots()
                      : null,
                  builder: (ctx, snapshot) {
                    if (snapshot.data == null)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.all(5),
                              child: Text(
                                'No starred items',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (ctx, index) => ListTile(
                              leading: (snapshot.data.docs[index]
                                          .data()['imageUrl'] !=
                                      null)
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot
                                          .data.docs[index]
                                          .data()['imageUrl']))
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.no_photography,
                                        color: Colors.red,
                                      ),
                                    ),
                              title: Text(snapshot.data.docs[index]['name']),
                              onTap: () {
                                String itemId = snapshot.data.docs[index].id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailScreen(
                                      item: snapshot.data.docs[index].data(),
                                      itemId: itemId,
                                    ),
                                  ),
                                ).then((val) {
                                  setState(() {
                                    Navigator.pushReplacement(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new StarredItemsScreen()));
                                  });
                                });
                              },
                            ));
                  })),
        ],
      ),
    );
  }
}
