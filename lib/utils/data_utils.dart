import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:transmusicales/models/dataset.dart';

List<Dataset> _items = [];
// Fetch content from the json file
Future<List<Dataset>> readJson(String dataPath) async {
  final String response = await rootBundle.loadString(dataPath);
  final data = await json.decode(response);
  _items.clear();
  data.forEach((item) {
    Dataset dataset = Dataset();
    dataset.id = item['recordid'] ?? '';
    dataset.spotify = item['fields']['spotify'] ?? '';
    dataset.cou_official_lang_code =
        item['fields']['cou_official_lang_code'] ?? '';
    dataset.cou_onu_code = item['fields']['cou_onu_code'] ?? '';
    dataset.artistes = item['fields']['artistes'] ?? '';
    dataset.cou_iso2_code = item['fields']['cou_iso2_code'] ?? '';
    dataset.cou_iso3_code = item['fields']['cou_iso3_code'] ?? '';
    dataset.salle1 = item['fields']['1ere_salle'] ?? '';
    dataset.edition = item['fields']['edition'] ?? '';
    dataset.cou_text_sp = item['fields']['cou_text_sp'] ?? '';
    dataset.date1 = item['fields']['1ere_date'] ?? '';
    dataset.cou_is_ilomember = item['fields']['cou_is_ilomember'] ?? '';
    dataset.annee = item['fields']['annee'] ?? '';
    dataset.deezer = item['fields']['deezer'] ?? '';
    dataset.cou_text_en = item['fields']['cou_text_en'] ?? '';
    dataset.origine_pays1 = item['fields']['origine_pays1'] ?? '';

    if (item['fields']['geo_point_2d'] != null) {
      dataset.x = item['fields']['geo_point_2d'][0];
      dataset.y = item['fields']['geo_point_2d'][1];
    }
    _items.add(dataset);
  });

  return _items;
}



Dataset? findDatasetById(String id) {
  var findById = (obj) => obj.id == id;
  var dataset = _items.where(findById);
  return dataset.isNotEmpty ? dataset.first : null;
}
