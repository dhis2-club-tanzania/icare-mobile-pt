
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dropdown_search/dropdown_search.dart';

class QRCodeScanningPage extends StatefulWidget {
  final String authToken;
  final String baseUrl;
  QRCodeScanningPage({Key? key, required this.authToken, required this.baseUrl}) : super(key: key);
  @override
  _QRCodeScanningPagePageState createState() => _QRCodeScanningPagePageState();
}

class _QRCodeScanningPagePageState extends State<QRCodeScanningPage> {
  String barCodeScanner = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Scan & Save details'),),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:<Widget> [
              // Container(
              //     child: new Row(
              //       children: [
              //         Container(
              //           child: ElevatedButton(
              //             onPressed: () {
              //               Navigator.of(context).pop();
              //             },
              //             child: Text("Back",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       ],
              //     )
              // ),
              SizedBox(
                height: 2.5,
              ),
              Container(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: _scan(),
                        builder: (BuildContext context,AsyncSnapshot snapshot) {
                          barCodeScanner = snapshot.data;
                          return Text(snapshot.data);
                        }
                    ),
                    Container(
                      child: barCodeScanner != '' || barCodeScanner != "-1" ? DropdownSearch<String>(
                          mode: Mode.MENU,
                          isFilteredOnline: true,
                          showClearButton: true,
                          showSelectedItems: true,
                          showSearchBox: true,
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Search a drug",
                            labelText: "Drugs" + barCodeScanner,
                            filled: true,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF01689A)),
                            ),
                          ),
                          items:  getOptions(),
                          onChanged: print): Text(''),
                    )
                  ],
                )
              )
            ],
          ),
        )
    );
  }
}


getOptions() {
  return  ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'];
}



Future<dynamic> _scan() async {
  String? barcode =  await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
  // await scanner.scan();
  if (barcode == null) {
    return 'UNKNOWN';
  } else {
   return barcode;
  }
}
