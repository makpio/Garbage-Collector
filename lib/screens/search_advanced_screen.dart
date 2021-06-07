import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class AdvancedSearchScreen extends StatefulWidget {
  //static const routeName = '/advanced-search';
  final Function onSelectAdvancedParams;
  final AdvancedSearchParams initParams;

  AdvancedSearchScreen({
    Key key,
    @required this.onSelectAdvancedParams,
    @required this.initParams,
  }) : super(key: key);

  @override
  _AdvancedSearchScreenState createState() => _AdvancedSearchScreenState();

  // AdvancedSearchScreen(this.onSelectAdvancedParams, this.initParams);

  // @override
  // _AdvancedSearchScreenState createState() => _AdvancedSearchScreenState();
}

class AdvancedSearchParams {
  final LatLng _location;
  final double _range;

  LatLng get location => _location;

  double get range => _range;

  AdvancedSearchParams(this._location, this._range);
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen> {
  final MapController controller = new MapController();
  LatLng _selectedLocation;
  double _selectedRange = 1;

  void _saveLocation() {
    Navigator.of(context)
        .pop(AdvancedSearchParams(_selectedLocation, _selectedRange));
  }

  @override
  void initState() {
    if (widget.initParams != null) {
      if (widget.initParams.range != null) {
        this._selectedRange = widget.initParams.range;
      } else {
        this._selectedRange = 1;
      }
      if (widget.initParams.location != null &&
          widget.initParams.location.latitude != null) {
        this._selectedLocation = widget.initParams.location;
      } else {
        this._selectedLocation = null;
      }
    } else {
      this._selectedLocation = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Advanced Search Options'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.height - 122,
                    child: FlutterMap(
                      mapController: controller,
                      options: new MapOptions(
                        center: this._selectedLocation != null
                            ? _selectedLocation
                            : new LatLng(52.23, 21.01),
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
                    ),
                  ),
                  Container(
                    height: 30,
                    decoration: new BoxDecoration(color: Colors.transparent),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _selectedRange == 1
                                ? '  Maximal Range < 1 km'
                                : _selectedRange == 10
                                    ? '  Maximal Range 10km+'
                                    : '  Maximal Range ' +
                                        _selectedRange.toString() +
                                        ' km',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: Colors.blue[700],
                              inactiveTrackColor: Colors.blue[100],
                              // //trackShape: RoundedRectSliderTrackShape(),
                              // trackHeight: 4.0,
                              // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                              // thumbColor: Colors.redAccent,
                              // overlayColor: Colors.red.withAlpha(32),
                              // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                              // // tickMarkShape: RoundSliderTickMarkShape(),
                              // activeTickMarkColor: Colors.red[700],
                              // inactiveTickMarkColor: Colors.red[100],
                              // valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                              // valueIndicatorColor: Colors.redAccent,
                              // valueIndicatorTextStyle: TextStyle(
                              //   color: Colors.white,
                              // ),
                            ),
                            child: Slider(
                              label: _selectedRange == 1
                                  ? 'Range < 1 km'
                                  : _selectedRange == 10
                                      ? 'Range 10km+'
                                      : 'Range ' +
                                          _selectedRange.toString() +
                                          ' km',
                              min: 1,
                              max: 10,
                              activeColor: Colors.blue,
                              //inactiveColor: Colors.blue,
                              autofocus: true,
                              value: _selectedRange,
                              onChanged: (double newValue) {
                                setState(() {
                                  _selectedRange = newValue;
                                });
                              },
                              divisions: 9,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Accept'),
                  onPressed: _saveLocation,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    elevation: 10,
                    shadowColor: Colors.red,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )),
              // Expanded(
              //     child: FlutterMap(
              //   mapController: controller,
              //   options: new MapOptions(
              //     center: new LatLng(52.23, 21.01),
              //     zoom: 13.0,
              //     maxZoom: 18,
              //     minZoom: 4,
              //     onTap: (point) {
              //       controller.move(point, 13);
              //       setState(() {
              //         _selectedLocation = point;
              //       });
              //     },
              //   ),
              //   layers: [
              //     new TileLayerOptions(
              //         urlTemplate:
              //             "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              //         subdomains: ['a', 'b', 'c']),
              //     new MarkerLayerOptions(
              //       markers: [
              //         new Marker(
              //           width: 40.0,
              //           height: 40.0,
              //           point: _selectedLocation == null
              //               ? null
              //               : _selectedLocation,
              //           builder: (ctx) => new Container(
              //             child: Icon(
              //               Icons.room,
              //               color: Colors.red,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // )),
              // Container(
              //   //width: double.infinity,
              //   height: 30,
              //   decoration: new BoxDecoration(color: Colors.transparent),
              //   child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: <Widget>[
              //         Text(
              //           'Maximal Range:  ',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.white,
              //           ),
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //         SliderTheme(
              //           data: SliderThemeData(
              //             activeTrackColor: Colors.blue[700],
              //             inactiveTrackColor: Colors.blue[100],
              //             // //trackShape: RoundedRectSliderTrackShape(),
              //             // trackHeight: 4.0,
              //             // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              //             // thumbColor: Colors.redAccent,
              //             // overlayColor: Colors.red.withAlpha(32),
              //             // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              //             // // tickMarkShape: RoundSliderTickMarkShape(),
              //             // activeTickMarkColor: Colors.red[700],
              //             // inactiveTickMarkColor: Colors.red[100],
              //             // valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              //             // valueIndicatorColor: Colors.redAccent,
              //             // valueIndicatorTextStyle: TextStyle(
              //             //   color: Colors.white,
              //             // ),
              //           ),
              //           child: Slider(
              //             label: _selectedRange == 1
              //                 ? 'Range < 1 km'
              //                 : _selectedRange == 10
              //                     ? 'Range 10km+'
              //                     : 'Range ' +
              //                         _selectedRange.toString() +
              //                         ' km',
              //             min: 1,
              //             max: 10,
              //             activeColor: Colors.blue,
              //             //inactiveColor: Colors.blue,
              //             autofocus: true,
              //             value: _selectedRange,
              //             onChanged: (double newValue) {
              //               setState(() {
              //                 _selectedRange = newValue;
              //               });
              //             },
              //             divisions: 9,
              //           ),
              //         ),
              //       ]),
              // ),
              // ElevatedButton.icon(
              //     icon: Icon(Icons.check),
              //     label: Text('Accept'),
              //     onPressed: _saveLocation,
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.red,
              //       elevation: 10,
              //       shadowColor: Colors.red,
              //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //     )),
            ]));
  }
}
