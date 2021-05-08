import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/screens/item_detail_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'add_item_screen.dart';

class MyItemsScreen extends StatefulWidget {
  static const routeName = '/user-items-list';

  @override
  _MyItemsScreenState createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Items',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddItemScreen.routeName);
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.all(5),
                              child: CircularProgressIndicator(),
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
                                String docId = snapshot.data.docs[index].id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailScreen(
                                      item: snapshot.data.docs[index].data(),
                                      docId: docId,
                                    ),
                                  ),
                                );
                              },
                            ));
                  })),
        ],
      ),
    );
  }
}
