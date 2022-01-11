

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:icaremobile/models/location.model.dart';

Future <List<LocationModel>> getStoreLocations(basicAuthToken, baseUrl, userInfo) async {
  if (userInfo != '') {
    final dynamic response = await http.get(
      baseUrl + '/openmrs/ws/rest/v1/location?tag=store&v=custom:(uuid,display,name,tags)',headers: <String, String>{'Authorization': basicAuthToken},
    );
    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> responseMap = json.decode(response.body);
      final List<LocationModel> results = LocationModel.fromJsonList(responseMap["results"]);
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