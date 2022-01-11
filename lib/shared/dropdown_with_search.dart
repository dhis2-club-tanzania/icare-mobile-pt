import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '/models/drug_response_model.dart';
import 'drug_service.dart';

typedef void DropDownCallback(dynamic data);

class SearchFromOnlineDropDown extends StatelessWidget {
  SearchFromOnlineDropDown({required this.searchingText, required this.basicAuthToken, required this.baseUrl, required this.getSelectedItem});
  final dynamic searchingText;
  final String basicAuthToken;
  final String baseUrl;
  final DropDownCallback getSelectedItem;
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: DropdownSearch<DataModel>(
          mode: Mode.MENU,
          isFilteredOnline: true,
          showClearButton: true,
          maxHeight: 500,
          showSearchBox: true,
          dropdownSearchDecoration: InputDecoration(
            hintText: "Search a drug",
            labelText: "Drugs",
            filled: true,
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF01689A)),
            ),
          ),
          onFind:  (String? filter) => searchDrugs(basicAuthToken, baseUrl, filter),
          itemAsString: (DataModel? data) => data != null ? data.dataAsString(): '',
          onChanged: (data) => {
            getSelectedItem(data)
          }),
    );
  }
}



