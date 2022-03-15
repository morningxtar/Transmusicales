import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:transmusicales/services/fetch_data.dart';
import 'package:transmusicales/utils/navigation_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/models/dataset.dart';
import 'package:transmusicales/utils/data_utils.dart';

import '../database/database.dart';
import 'artist.dart';

class ArtistsSreen extends StatefulWidget {
  final String title;
  final SharedPreferences sharedPreferences;

  @override
  _ArtistsSreen createState() => _ArtistsSreen();

  const ArtistsSreen(
      {Key? key, required this.title, required this.sharedPreferences})
      : super(key: key);
}

class _ArtistsSreen extends State<ArtistsSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController editingController = TextEditingController();
  late ScrollController controller;

  String searchString = "";
  String? email;
  String? genreSearchString = "artist";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Artist"), value: "artist"),
      const DropdownMenuItem(child: Text("Pays"), value: "pays"),
      const DropdownMenuItem(child: Text("Annee"), value: "annee"),
    ];
    return menuItems;
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      email = widget.sharedPreferences.getString('email')!;
    });
  }

  Widget _artistScreen(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)), //bo
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton(
                      underline: Container(),
                      items: dropdownItems,
                      value: genreSearchString,
                      onChanged: (String? newValue) {
                        setState(() {
                          genreSearchString = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchString = value;
                    });
                  },
                  controller: editingController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Rechercher",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Dataset>>(
            stream: Stream.fromFuture(readJson('assets/data/out.json')),
            builder: (context, AsyncSnapshot<List<Dataset>> snapshot) {
              print(snapshot.data?.length);
              if (snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        Dataset dataset = snapshot.data![index];
                        switch (genreSearchString) {
                          case 'annee':
                            return snapshot.data![index].annee
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? _artist(dataset, context)
                                : Container();

                          case 'pays':
                            return snapshot.data![index].origine_pays1
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? _artist(dataset, context)
                                : Container();
                          default:
                            return snapshot.data![index].artistes
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? _artist(dataset, context)
                                : Container();
                        }
                      });
                } else if (snapshot.hasError) {
                  if (kDebugMode) {
                    print("${snapshot.error}");
                  }
                  return const Center(child: CircularProgressIndicator());
                }
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
            },
          ),
        ),
      ],
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

  InkWell _artist(Dataset dataset, BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.4;
    return InkWell(
      onTap: () {
        NavigationUtils.push(
            context,
            ArtistSreen(
              dataset: dataset,
              title: 'Les Transmusicales',
              sharedPreferences: widget.sharedPreferences,
            ));
      },
      child: Card(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  child: Text(dataset.artistes),
                  width: cWidth,
                ),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: getNoteByIdAndUser(dataset.id, email!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              double myNote = snapshot.data!.docs.isNotEmpty
                                  ? snapshot.data!.docs.first['note']
                                  : 0.0;
                              return RatingBar.builder(
                                initialRating: myNote,
                                minRating: 0,
                                direction: Axis.horizontal,
                                itemSize:
                                    MediaQuery.of(context).size.width / 25,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  addNotesArtist(dataset.id, email!, rating);
                                },
                              );
                            } else{
                              return const Center(
                                  child: LinearProgressIndicator());
                            }
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 15,
                      height: MediaQuery.of(context).size.width / 15,
                      decoration: const BoxDecoration(
                          color: Colors.amber, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: getNoteById(dataset.id),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              note = snapshot.data!.docs.isNotEmpty
                                  ? snapshot.data!.docs.first['note']
                                  : 0.0;
                              return Text(
                                note.toString(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 10),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    ),
                  ],
                )),
                Visibility(
                  visible: dataset.spotify.isNotEmpty,
                  child: IconButton(
                    onPressed: () async {
                      if (await canLaunch(dataset.spotify)) {
                        // Launch the url which will open Spotify
                        launch(dataset.spotify);
                      }
                    },
                    icon: Image.asset('assets/icons/spotify.png'),
                    iconSize: MediaQuery.of(context).size.width / 15,
                  ),
                ),
                IconButton(
                    onPressed: () => addOrRemoveFavArtist(dataset, email!),
                    icon: const Icon(Icons.favorite),
                    iconSize: MediaQuery.of(context).size.width / 15),
              ],
            )
          ],
        ),
      ),
    );
  }
}
