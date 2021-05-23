import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_item_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final item;
  final itemId;

  ItemDetailScreen({
    Key key,
    @required this.item,
    @required this.itemId,
  }) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool isStarred;

  void _checkIfStarred() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((user) {
      var starredItems = user.data()['starredItems'] ?? [];
      setState(() {
        isStarred = starredItems.contains(widget.itemId) ? true : false;
      });
    });
  }

  void _starItem() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'starredItems': FieldValue.arrayUnion([widget.itemId.toString()]),
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Theme.of(context).errorColor,
              ),
            ));

    _checkIfStarred();
  }

  void _unstarItem() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({
      'starredItems': FieldValue.arrayRemove([widget.itemId.toString()]),
    }).catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: Theme.of(context).errorColor,
              ),
            ));

    _checkIfStarred();
  }

  @override
  void initState() {
    _checkIfStarred();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.item['name'],
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FirebaseAuth.instance.currentUser.uid == widget.item['user']
              ? IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemScreen(
                          item: widget.item,
                          itemId: widget.itemId,
                        ),
                      ),
                    );
                  },
                )
              : isStarred == true
                  ? IconButton(
                      icon: Icon(Icons.star_outlined),
                      onPressed: () {
                        _unstarItem();
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.star_border),
                      onPressed: () {
                        _starItem();
                      },
                    ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 500,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                    ),
                    child: widget.item['imageUrl'] != null
                        ? Image.network(
                            widget.item['imageUrl'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Text(
                            'No image selected',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                    alignment: Alignment.center,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone_android_outlined,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "123456",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ]),
                        ),
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.mail_outline,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "12@34.56",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                    ),
                    child: (widget.item['location_lng'] != null &&
                            widget.item['location_lat'] != null)
                        ? FlutterMap(
                            options: new MapOptions(
                              center: new LatLng(widget.item['location_lat'],
                                  widget.item['location_lng']),
                              zoom: 13.0,
                              maxZoom: 18,
                              minZoom: 4,
                              interactive: false,
                            ),
                            layers: [
                              new TileLayerOptions(
                                  urlTemplate:
                                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']),
                              new MarkerLayerOptions(
                                markers: [
                                  new Marker(
                                    width: 40.0,
                                    height: 40.0,
                                    point: new LatLng(
                                        widget.item['location_lat'],
                                        widget.item['location_lng']),
                                    builder: (ctx) => new Container(
                                      child: Icon(
                                        Icons.room,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Text(
                            'No location selected',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextButton.icon(
                          icon: Icon(Icons.location_on),
                          label: Text(
                            'Open in GoogleMaps',
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () async {
                            final lat = widget.item['location_lat'];
                            final lng = widget.item['location_lng'];
                            final url =
                                'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
