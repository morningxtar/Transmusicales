import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/models/dataset.dart';
import 'package:transmusicales/utils/data_utils.dart';
import 'package:transmusicales/utils/navigation_utils.dart';

import '../database/database.dart';
import '../models/comment.dart';
import '../services/auth_services.dart';
import 'artists.dart';

class ArtistSreen extends StatefulWidget {
  final String title;
  final Dataset dataset;
  final SharedPreferences sharedPreferences;

  @override
  _ArtistSreen createState() => _ArtistSreen();

  const ArtistSreen(
      {Key? key,
      required this.title,
      required this.dataset,
      required this.sharedPreferences})
      : super(key: key);
}

class _ArtistSreen extends State<ArtistSreen> {

  @override
  void initState() {
    super.initState();
    print(widget.dataset.id);
  }

  Widget _artistScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            NavigationUtils.pop(context);
            // Navigator.pop(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             ArtistsSreen(
            //               title: 'Les Transmusicales',
            //               sharedPreferences: widget.sharedPreferences,
            //               datasets: ,
            //             )));
          }
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                logoutApp();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCommentStream(widget.dataset.id),
        builder:
            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  CommentArtist comment = CommentArtist(
                      contenu: snapshot.data!.docs[index]
                      ['comment'],
                      pseudo: snapshot.data!.docs[index]
                      ['user']);
                  return _comment(comment, context);
                });
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print("${snapshot.error}");
            }
            return const Center(
                child: CircularProgressIndicator());
          }
          return const Center(
              child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    CommentArtist comment = CommentArtist(
        pseudo: widget.sharedPreferences.getString('email'),
        id: widget.dataset.id);

    return Scaffold(
        backgroundColor: Colors.blue,
        body: _artistScreen(context),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.comment),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.blue,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 300.0,
                                ),
                                child: TextFormField(
                                  maxLines: null,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Champ obligatoire';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    comment.contenu = value!;
                                  },
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Builder(
                                    builder: (context) => MaterialButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          addCommentsArtist(comment);
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text(
                                        'Commenter',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'SFUIDisplay',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      color: Colors.blue,
                                      elevation: 0,
                                      minWidth: 400,
                                      height: 50,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ));
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final Dataset dataset;

  const MyDelegate(this.dataset);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return Stack(
      overflow: Overflow.clip,
      fit: StackFit.expand,
      children: [
        Column(
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    color: Colors.black,
                  ),
                  Opacity(
                    opacity: 1 - shrinkPercentage,
                    child: Container(
                      height: 900,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        alignment: FractionalOffset.topCenter,
                        image: NetworkImage(
                            'https://66.media.tumblr.com/c063f0b98040e8ec4b07547263b8aa15/tumblr_inline_ppignaTjX21s9on4d_540.jpg'),
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
            )
          ],
        ),
        Stack(
          overflow: Overflow.clip,
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: max(1 - shrinkPercentage * 6, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            dataset.artistes,
                            style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            dataset.annee,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(child: Container()),
            )
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => 400;

  @override
  double get minExtent => 110;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

Card _comment(CommentArtist commentArtist, BuildContext context) {
  double cWidth = MediaQuery.of(context).size.width * 0.75;
  return Card(
    elevation: 5,
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              commentArtist.pseudo.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: cWidth, child: Text(commentArtist.contenu.toString())),
          ],
        ),
      ],
    ),
  );
}
