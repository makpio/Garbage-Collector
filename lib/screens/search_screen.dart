import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/screens/item_detail_screen.dart';
import 'package:garbage_collector/screens/search_advanced_screen.dart';
import 'dart:math';
import 'add_item_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  AdvancedSearchParams advancedSearchParams;
  bool isAdvancedMode = false;

  void _advancedSearch() async {
    final newSearchParams = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvancedSearchScreen(
          onSelectAdvancedParams: null,
          initParams: advancedSearchParams,
        ),
      ),
    );
    setState(() {
      advancedSearchParams = newSearchParams;
      if (advancedSearchParams.location != null &&
          advancedSearchParams.range != null) {
        isAdvancedMode = true;
      }
    });
  }

  double getDistanceFromLatLonInKm(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  double deg2rad(deg) {
    return deg * (pi / 180);
  }

  bool isInRange(double lng, double lat) {
    print('IS IN RANGE');
    print(lat);
    double distance = getDistanceFromLatLonInKm(
        lat,
        lng,
        advancedSearchParams.location.latitude,
        advancedSearchParams.location.longitude);
    print(distance);
    if (distance <= advancedSearchParams.range)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search Results',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _searchController.text = '';
                advancedSearchParams = AdvancedSearchParams(null, null);
                isAdvancedMode = false;
                //TO DO refresh all parameters
              });
              //TO DO refresh all parameters
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              controller: _searchController,
              onChanged: (text) => {setState(() {})},
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(),
                labelText: "Search",
              ),
            ),
          ),
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('items')
                      .where('name',
                          isGreaterThanOrEqualTo: _searchController.text)
                      .where('name',
                          isLessThanOrEqualTo:
                              _searchController.text + '\uf8ff')
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
                        //separatorBuilder: (context, index) {
                        //   return Divider();
                        //},
                        itemBuilder: (ctx, index) {
                          if ((!isAdvancedMode ||
                                  advancedSearchParams.range == 10) ||
                              (snapshot.data.docs[index]
                                          .data()['location_lng'] !=
                                      null &&
                                  snapshot.data.docs[index]
                                          .data()['location_lat'] !=
                                      null &&
                                  isInRange(
                                      snapshot.data.docs[index]
                                          .data()['location_lng'],
                                      snapshot.data.docs[index]
                                          .data()['location_lat']))) {
                            return ListTile(
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
                              title:
                                  (snapshot.data.docs[index].data()['name'] !=
                                          null)
                                      ? Text(snapshot.data.docs[index]['name'])
                                      : null,
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
                                );
                              },
                            );
                          } else {
                            return Visibility(
                                visible: false, child: Container());
                          }
                        });
                  })),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text('Advanced search options'),
              onPressed: _advancedSearch,
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
