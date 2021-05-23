import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class AdvancedSearchScreen extends StatefulWidget {
  static const routeName = '/advanced-search';
  @override
  _AdvancedSearchScreenState createState() => _AdvancedSearchScreenState();
}

class BoxedReturns {
  final LatLng location;
  final String range;

  BoxedReturns(this.location, this.range);
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final MapController controller = new MapController();
  String dropdownValue = 'One';
  LatLng _selectedLocation;
  String _selectedRange;

  void _saveLocation() {
    Navigator.of(context).pop(BoxedReturns(_selectedLocation, _selectedRange));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Advanced Search Options'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
                  hint: Text('Choose a maximal range'),
                  value: _selectedRange,
                  isExpanded: true,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    backgroundColor: Colors.transparent,
                  ),
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRange = newValue;
                    });
                  },
                  items: <String>[
                    'less than 1km',
                    '1km',
                    '2km',
                    '5km',
                    '10km',
                    'over 10km',
                  ].map<DropdownMenuItem>((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                  child: FlutterMap(
                mapController: controller,
                options: new MapOptions(
                  center: new LatLng(52.23, 21.01),
                  zoom: 13.0,
                  maxZoom: 18,
                  minZoom: 4,
                  onTap: (point) {
                    controller.move(point, 13);
                    setState(() {
                      _selectedLocation = point;
                    });
                  },
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
                        point: _selectedLocation == null
                            ? null
                            : _selectedLocation,
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
              )),
              ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Accept'),
                  onPressed: _saveLocation,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    elevation: 10,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )),
            ]));
  }
}
