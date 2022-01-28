

import 'package:flutter/material.dart';

import '/models/drug_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future <List<DataModel>> searchDrugs(basicAuthToken, baseUrl, searchingText) async {
  if (searchingText != '') {
    final dynamic response = await http.get(
      baseUrl + '/openmrs/ws/rest/v1/drug?v=custom:(uuid,display,concept:(uuid,display))&limit=10&q=' + searchingText,headers: <String, String>{'Authorization': basicAuthToken},
    );
    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> responseMap = json.decode(response.body);
      final List<DataModel> results = DataModel.fromJsonList(responseMap["results"]);
      if (results != null) {
        return results;
      }
    } else {
      throw Exception('Failed');
    }
  } else {
    return [];
  }

  return [];
}


Future <ConceptReferenceTermModel> createDrugReferenceTerm(String baseUrl, String basicAuthToken, data) async {
  final dynamic response = await http.post(
    baseUrl + '/openmrs/ws/rest/v1/conceptreferenceterm',body: jsonEncode(data), headers: <String, String>{'Authorization': basicAuthToken, 'Content-type': 'application/json;charset=utf-8'},
  );
  final Map<String, dynamic> responseMap = json.decode(response.body);
  return ConceptReferenceTermModel.fromJson(responseMap);
}

Future <DrugReferenceMapModel> createDrugReferenceMap(String baseUrl, String basicAuthToken, data) async {
  final dynamic response = await http.post(
    baseUrl + '/openmrs/ws/rest/v1/drugreferencemap',body: jsonEncode(data), headers: <String, String>{'Authorization': basicAuthToken, 'Content-type': 'application/json;charset=utf-8'},
  );
  final Map<String, dynamic> responseMap = json.decode(response.body);
  return DrugReferenceMapModel.fromJson(responseMap);
}


Future <Map<String, Object>> saveStock(String baseUrl, String basicAuthToken, data) async {
  String path = baseUrl + '/openmrs/ws/rest/v1/store/ledger';
  print(path);
  print(jsonEncode(data));
  final dynamic response = await http.post(
    path,body: jsonEncode(data), headers: <String, String>{'Authorization': basicAuthToken, 'Content-type': 'application/json;charset=utf-8'},
  );
  final Map<String, Object> responseMap = json.decode(response.body);
  return responseMap;
}

Future <Map<String, Object>> getBillableItemUsingConceptUuid(String baseUrl, String basicAuthToken, conceptUuid) async {
  final String path = baseUrl + '/openmrs/ws/rest/v1/icare/itemByDrugConcept/' + conceptUuid;
  final dynamic response = await http.get(
    path,headers: <String, String>{'Authorization': basicAuthToken},
  );
  final Map<String, Object> responseMap = json.decode(response.body);
  return responseMap;
}


// STOCK STATUS
Future <List<DropdownMenuItem<dynamic>>> getStockStatusOfTheItem(String baseUrl, String basicAuthToken, String itemUuid) async {
  final String path = baseUrl + '/openmrs/ws/rest/v1/store/item/' + itemUuid +'/stock';
  final dynamic response = await http.get(
    path,headers: <String, String>{'Authorization': basicAuthToken},
  );
  final stockItems = json.decode(response.body);
  final stockItemsList = stockItems.map((item) => jsonEncode(item)).toList();
  final uniqueJsonList = stockItemsList.toSet().toList();
  final formattedUniqJsonList = uniqueJsonList.map((item) => jsonDecode(item)).toList();
  Map<String, dynamic> mp = {};
  for (var item in formattedUniqJsonList) {
    mp[item['batch']] = item;
  }
  var filteredList = mp.values.toList();
  List<DropdownMenuItem<dynamic>> responseMap = filteredList.map<DropdownMenuItem<dynamic>>((item) {
    return DropdownMenuItem<dynamic>(
      value: jsonEncode(item),
      child: Text(item['batch'], overflow: TextOverflow.ellipsis),
    );
  }).toList();
  return responseMap == null ? []: responseMap;
}
