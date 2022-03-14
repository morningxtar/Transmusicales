import 'package:cloud_firestore/cloud_firestore.dart';

class Dataset{
  String id;
  String spotify;
  String cou_official_lang_code;
  String cou_onu_code;
  String artistes;
  String cou_iso2_code;
  String cou_iso3_code;
  String salle1;
  String edition;
  String cou_text_sp;
  var date1;
  String cou_is_ilomember;
  String annee;
  String deezer;
  String cou_text_en;
  String origine_pays1;
  double note;
  double myNote;
  double x;
  double y;

  Dataset({
    this.id = '',
    this.spotify = '',
    this.cou_official_lang_code = '',
    this.cou_onu_code = '',
    this.artistes = '',
    this.cou_iso2_code = '',
    this.cou_iso3_code = '',
    this.salle1 = '',
    this.edition = '',
    this.cou_text_sp = '',
    this.date1 = '',
    this.cou_is_ilomember = '',
    this.annee = '',
    this.deezer = '',
    this.cou_text_en = '',
    this.origine_pays1 = '',
    this.note = 0,
    this.myNote = 0,
    this.x = 0,
    this.y = 0,
  });

  factory Dataset.fromJson(Map<String, dynamic> json) {
    return Dataset(
      id: json['id'],
      spotify: json['spotify'],
      artistes: json['artistes'],
      deezer: json['deezer'],
    );
  }
  @override
  String toString() {
    return 'dataset id: ' + id + ' | artistes: ' + artistes + ' | spotify: ' + spotify;
  }
}