import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController controller = new MapController();
  LatLng _selectedLocation;

  void _saveLocation() {
    Navigator.of(context).pop(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                  icon: Icon(Icons.add),
                  label: Text('Choose Location'),
                  onPressed: _saveLocation,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    elevation: 10,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )),
            ]));
  }
}
