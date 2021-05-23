import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garbage_collector/screens/item_detail_screen.dart';
import 'package:garbage_collector/screens/search_advanced_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  
  void _advancedSearch() async {
    final advancedSearchParams =
        await Navigator.of(context).pushNamed(AdvancedSearchScreen.routeName);

    setState(() {});
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
                      .where('name'.toLowerCase(),
                          isGreaterThanOrEqualTo:
                              _searchController.text.toLowerCase())
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
                            ));
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
