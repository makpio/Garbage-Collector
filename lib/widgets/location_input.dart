import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectLocation;

  LocationInput(this.onSelectLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng _location;

  final MapController controller = new MapController();

  void _selectLocation() async {
    final selectedLocation =
        await Navigator.of(context).pushNamed(MapScreen.routeName);

    _location = selectedLocation;
    print(_location.latitude);
    setState(() {
      _location = selectedLocation;
      controller.move(selectedLocation, 15);
    });

    widget.onSelectLocation(_location);
  }

  Future<void> _getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    // LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData _locationData = await location.getLocation();

    setState(() {
      _location = LatLng(_locationData.latitude, _locationData.longitude);
      controller.move(_location, 15);
    });
    widget.onSelectLocation(_location);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 200,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black12),
            ),
            child: _location == null
                ? FlutterMap(
                    mapController: controller,
                    options: new MapOptions(
                      center: new LatLng(52, 19),
                      zoom: 5.0,
                      maxZoom: 18,
                      minZoom: 4,
                      interactive: false,
                    ),
                    layers: [
                      new TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c']),
                    ],
                  )
                // Text(
                //     'No location selected',
                //     textAlign: TextAlign.center,
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(fontWeight: FontWeight.bold),
                //   )
                : FlutterMap(
                    mapController: controller,
                    options: new MapOptions(
                      center: _location,
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
                            point: _location,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.location_on),
                label: Text(
                  'Current Location',
                  textAlign: TextAlign.center,
                ),
                onPressed: _getLocation,
              ),
            ),
            Expanded(
              child: TextButton.icon(
                icon: Icon(Icons.map),
                label: Text(
                  'Select Location',
                  textAlign: TextAlign.center,
                ),
                onPressed: _selectLocation,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
