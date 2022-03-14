import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transmusicales/utils/data_utils.dart';

import '../models/dataset.dart';

class ArtistMap extends StatefulWidget {
  final String title;
  const ArtistMap({Key? key, required this.title}) : super(key: key);

  @override
  _ArtistMapStateState createState() => _ArtistMapStateState();
}

class _ArtistMapStateState extends State<ArtistMap> {

  late GoogleMapController mapController;
  late Position _currentPosition;
  late LatLng _center = LatLng(5.37796973150617, -3.96620526419914);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  late Future<List<Dataset>> datasets;

  List<Circle> circles = [];
  List<Marker> markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      datasets = readJson('assets/data/out.json');
      datasets.then((value) {
        for(int i=0; i<2594; i++ ){
          circles.add(Circle(
            circleId: CircleId(value[i].id),
            center: LatLng(value[i].x, value[i].y),
            fillColor: const Color.fromARGB(70, 150, 50, 50),
            strokeColor: Colors.red,
            radius: 2000,
            strokeWidth: 1,
            consumeTapEvents: true,
          ));

          markers.add(Marker(
            markerId: MarkerId(value[i].id),
            position: LatLng(value[i].x, value[i].y),
            infoWindow: InfoWindow(
                title: value[i].artistes,
                snippet: value[i].annee),
          ));

          // mapController.animateCamera(CameraUpdate.newCameraPosition(
          //   CameraPosition(
          //   bearing: 270.0,
          //   target: LatLng(
          //       element.x, element.y),
          //   tilt: 30.0,
          //   zoom: 17.0,
          // ),));
        }
        });

    });

  }

  Widget artistMap(BuildContext context) {

    Set<Circle> circle = Set.from(circles);
    Set<Marker> marker = Set.from(markers);

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Text(widget.title),
            Expanded(
              child: SizedBox(
                  child: Center(
                    child: GoogleMap(
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                                  () => PanGestureRecognizer()))
                          ..add(Factory<VerticalDragGestureRecognizer>(
                                  () => VerticalDragGestureRecognizer())),
                        tiltGesturesEnabled: true,
                        trafficEnabled: true,
                        onMapCreated: _onMapCreated,
                        mapToolbarEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 9,
                        ),
                        circles: circle,
                        markers: marker),
                  )),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          body: artistMap(context)),
    );
  }
}