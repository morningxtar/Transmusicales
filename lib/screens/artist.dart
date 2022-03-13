import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/models/dataset.dart';
import 'package:transmusicales/utils/data_utils.dart';

import '../database/database.dart';


class ArtistSreen extends StatefulWidget {
  final String title;

  @override
  _ArtistSreen createState() => _ArtistSreen();

  const ArtistSreen({Key? key, required this.title}) : super(key: key);
}

class _ArtistSreen extends State<ArtistSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _artistScreen(BuildContext context) {
    return Container(
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue,
      body: _artistScreen(context),
    );
  }
}
