import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart';

import '../models/album.dart';


Future<AlbumSpotify> fetchSpotifyAlbum(String albumId) async {
  AlbumSpotify albumSpotify = AlbumSpotify();


  var response =
      await http.get(Uri.parse('https://open.spotify.com/album/' + albumId));

  print(response.body);
  if (response.statusCode == 200) {
    var document = parse(response.body);

    albumSpotify.title = document
        .getElementsByTagName('meta')
        .firstWhere((element) => element.attributes['property'] == 'og:title')
        .attributes['content'];

    albumSpotify.description = document
        .getElementsByTagName('meta')
        .firstWhere(
            (element) => element.attributes['property'] == 'og:description')
        .attributes['content'];

    albumSpotify.image = document
        .getElementsByTagName('meta')
        .firstWhere((element) => element.attributes['property'] == 'og:image')
        .attributes['content'];

    albumSpotify.url = document
        .getElementsByTagName('meta')
        .firstWhere((element) => element.attributes['property'] == 'og:url')
        .attributes['content'];

    albumSpotify.urlMusician = document
        .getElementsByTagName('meta')
        .firstWhere(
            (element) => element.attributes['property'] == 'music:musician')
        .attributes['content'];

    albumSpotify.description = document
        .getElementsByTagName('meta')
        .firstWhere(
            (element) => element.attributes['property'] == 'music:release_date')
        .attributes['content'];
  }

  return albumSpotify;
}
