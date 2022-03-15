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

  late LatLng _center = LatLng(5.37796973150617, -3.96620526419914);


  @override
  void initState() {
    super.initState();
  }

  Widget artistMap(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Text(widget.title),
            Expanded(
              child: SizedBox(
                  child: Center(
                    child: StreamBuilder<List<Dataset>>(
                      stream: Stream.fromFuture(readJson('assets/data/out.json')),
                      builder: (context, AsyncSnapshot<List<Dataset>> snapshot) {
                        if (snapshot.hasData) {
                          List<Circle> circles = [];
                          List<Marker> markers = [];

                          snapshot.data!.forEach((element) {
                            circles.add(Circle(
                              circleId: CircleId(element.id),
                              center: LatLng(element.x, element.y),
                              fillColor: const Color.fromARGB(70, 150, 50, 50),
                              strokeColor: Colors.red,
                              radius: 2000,
                              strokeWidth: 1,
                              consumeTapEvents: true,
                            ));

                            markers.add(Marker(
                              markerId: MarkerId(element.id),
                              position: LatLng(element.x, element.y),
                              infoWindow: InfoWindow(
                                  title: element.artistes,
                                  snippet: element.annee),
                            ));
                          });
                          Set<Circle> circle = Set.from(circles);
                          Set<Marker> marker = Set.from(markers);

                          return GoogleMap(
                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: true,
                              rotateGesturesEnabled: true,
                              scrollGesturesEnabled: true,
                              gestureRecognizers: Set()
                                ..add(Factory<PanGestureRecognizer>(
                                        () => PanGestureRecognizer()))..add(
                                    Factory<VerticalDragGestureRecognizer>(
                                            () =>
                                            VerticalDragGestureRecognizer())),
                              tiltGesturesEnabled: true,
                              trafficEnabled: true,
                              mapToolbarEnabled: true,
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 0,
                              ),
                              circles: circle,
                              markers: marker);
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      }
                    ),
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