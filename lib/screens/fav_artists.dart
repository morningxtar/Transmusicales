import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/database/database.dart';
import 'package:transmusicales/models/dataset.dart';
import 'package:transmusicales/utils/data_utils.dart';

class FavArtistsSreen extends StatefulWidget {
  final String title;

  @override
  _FavArtistsSreen createState() => _FavArtistsSreen();

  const FavArtistsSreen({Key? key, required this.title}) : super(key: key);
}

class _FavArtistsSreen extends State<FavArtistsSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController editingController = TextEditingController();

  //final Login _login = Login();
  String searchString = "";
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
  }

  Widget _favArtistScreen(BuildContext context) {
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
                      //dropdown background color
                      underline: Container(), //remove underline
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
          child: StreamBuilder<QuerySnapshot>(
            stream: getFavStream('lekouamelan@gmail.com'),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        Dataset? dataset =
                            findDatasetById(snapshot.data!.docs[index]['id']);

                        switch (genreSearchString) {
                          case 'annee':
                            return dataset!.annee
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? InkWell(
                                    onTap: () {
                                      print(dataset);
                                    },
                                    child: _artist(dataset),
                                  )
                                : Container();

                          case 'pays':
                            return dataset!.origine_pays1
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? InkWell(
                                    onTap: () {
                                      print(dataset);
                                    },
                                    child: _artist(dataset),
                                  )
                                : Container();
                          default:
                            return dataset!.artistes
                                    .toLowerCase()
                                    .contains(searchString.toLowerCase())
                                ? InkWell(
                                    onTap: () {
                                      print(dataset);
                                    },
                                    child: _artist(dataset),
                                  )
                                : Container();
                        }
                      });
                }
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: CircularProgressIndicator());
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
      body: _favArtistScreen(context),
    );
  }
}

Card _artist(Dataset dataset) {
  return Card(
    child: Column(
      children: [
        Row(
          children: [
            Text(dataset.artistes),
            IconButton(
                onPressed: () => addOrRemoveFavArtist(dataset.id,'lekouamelan@gmail.com'),
                icon: const Icon(Icons.favorite)
            )
          ],
        )
      ],
    ),
  );
}
