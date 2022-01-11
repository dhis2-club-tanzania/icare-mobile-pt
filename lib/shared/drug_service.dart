

import '/models/drug_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future <List<DataModel>> searchDrugs(basicAuthToken, baseUrl, searchingText) async {
  if (searchingText != '') {
    final dynamic response = await http.get(
      baseUrl + '/openmrs/ws/rest/v1/drug?limit=10&q=' + searchingText,headers: <String, String>{'Authorization': basicAuthToken},
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
  print("###############################################");
  print(data.runtimeType);
  print(jsonEncode(data));
  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  final dynamic response = await http.post(
    baseUrl + '/openmrs/ws/rest/v1/store/ledger',body: jsonEncode(data), headers: <String, String>{'Authorization': basicAuthToken, 'Content-type': 'application/json;charset=utf-8'},
  );
  print(response.body);
  final Map<String, Object> responseMap = json.decode(response.body);
  return responseMap;
}
