import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmusicales/main.dart';
import 'package:transmusicales/models/dataset.dart';
import 'package:transmusicales/services/fetch_data.dart';
import 'package:transmusicales/utils/data_utils.dart';
import 'package:transmusicales/utils/navigation_utils.dart';

import '../database/database.dart';
import '../models/album.dart';
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
  }

  Widget _artistScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            NavigationUtils.pop(context);
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
      body: Column(
        children: [
          artist(widget.dataset),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Commentaires',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
          ),
        ],
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

  Container artist(Dataset dataset){
    double cWidth = MediaQuery.of(context).size.width*0.4;
    AlbumSpotify? albumSpotify;
    if(widget.dataset.spotify != null){
      fetchSpotifyAlbum(widget.dataset.spotify).then((value) {
        albumSpotify = value;
      });
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x32000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: albumSpotify?.image != null ? Image.network(albumSpotify?.image) : Icon(Icons.no_photography)
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children:  [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Text(
                        'Artist(s) : ${dataset.artistes.toString()}',
                        style: const TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF242424),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Origine', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          dataset.origine_pays1,
                          style: const TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF57636C),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          )
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 24, 12),
                      child: Column(
                        children: [
                          const Text('Evènement', style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(
                            width: cWidth,
                            child: Text(
                                 widget.dataset.edition,
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 24, 12),
                    child: Column(
                      children: [
                        const Text('Date', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: cWidth,
                          child: Text(
                              widget.dataset.date1,
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 24, 12),
                    child: Column(
                      children: [
                        const Text('Salle', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: cWidth,
                          child: Text(
                              widget.dataset.salle1,
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF57636C),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

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
              'User : ${commentArtist.pseudo.toString()}',
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


