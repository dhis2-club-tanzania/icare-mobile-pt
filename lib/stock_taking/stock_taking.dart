
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icaremobile/shared/loaders.dart';
import 'package:icaremobile/shared/stock_data.dart';
import '/shared/drug_service.dart';
import '/models/drug_response_model.dart';
import '/shared/dropdown_with_search.dart';
import '/stock_taking/qrcode_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class StockTakingPage extends StatefulWidget {
  final String authToken;
  final String baseUrl;
  final dynamic locationDetails;
  StockTakingPage({Key? key, required this.authToken, required this.baseUrl, required this.locationDetails}) : super(key: key);
  @override
  _StockTakingPageState createState() => _StockTakingPageState();
}

class _StockTakingPageState extends State<StockTakingPage> {
  String scannedBarCode = '';
  DataModel selectedItem =DataModel(uuid: '', display: '');
  dynamic drugReferenceTerm = {
    'code': '',
    'conceptSource': ''
  };
  Future<void> _scan() async {
    String? barcode =  await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    setState(() {
      scannedBarCode = barcode;
    });
  }
  bool savingStock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: ListView(
          children: [
            scannedBarCode == '' ? FlatButton(
              onPressed: () =>_scan(),
              child: Center(
                child: Text("SCAN BAR/QR CODE ", style: TextStyle(color: Colors.blue)),
              ),
            ) : Center(
              child: FutureBuilder(
                  future: searchDrugs(widget.authToken, widget.baseUrl, scannedBarCode),
                  builder: (BuildContext context,AsyncSnapshot snapshot) {
                    return snapshot.hasData? Column(
                        children: [
                          Container(
                            child: snapshot.data.length > 0 ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 20,),
                                  child: Row(
                                    children: [
                                      Text(widget.locationDetails.display, textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                                      Spacer(),
                                      FlatButton(
                                        onPressed: () =>_scan(),
                                        child: Center(
                                          child: Text("SCAN BAR/QR CODE ", style: TextStyle(color: Colors.blue)),
                                        ),
                                      )
                                    ],
                                  ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(snapshot.data[0].display, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
                                  // CaptureFormData( headerText: drugWithGivenBarCode.display, formFields: formFields)
                                  Container(
                                    child: FutureBuilder(
                                      future: getBillableItemUsingConceptUuid(widget.baseUrl, widget.authToken, snapshot.data[0].concept['uuid']),
                                      builder: (BuildContext context, AsyncSnapshot snapShotData) {
                                        return snapShotData.hasData ?
                                        StockDataForm(authToken: widget.authToken,baseUrl: widget.baseUrl, conceptUuid: snapshot.data[0].concept['uuid'], locationUuid: widget.locationDetails.uuid, itemUuid: snapShotData.data['uuid']):
                                        Text('');
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ):
                            SearchFromOnlineDropDown(searchingText: '', basicAuthToken:widget.authToken, baseUrl: widget.baseUrl, getSelectedItem: (data) => {
                              setState(() => {
                                selectedItem = data
                              }),
                            }),
                          ),
                          selectedItem.uuid != '' && snapshot.data.length == 0 ? FutureBuilder(
                              future: createDrugReferenceTerm(widget.baseUrl, widget.authToken, {'code': scannedBarCode, 'conceptSource': '4ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD'}),
                              builder:  (BuildContext context,AsyncSnapshot snapshot) {
                                final ConceptReferenceTermModel createdReferenceTerm = snapshot.data;
                                return snapshot.hasData ?
                                FutureBuilder(
                                    future: createDrugReferenceMap(widget.baseUrl, widget.authToken, {'drug': {'uuid': selectedItem.uuid}, 'conceptMapType':'SAME-AS', 'conceptReferenceTerm': createdReferenceTerm.uuid}),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      return snapshot.hasData ?
                                      StockDataForm(authToken: widget.authToken,baseUrl: widget.baseUrl, conceptUuid: selectedItem.concept['uuid'], locationUuid: widget.locationDetails.uuid, itemUuid: '',)
                                          : LinearProgressLoader('Saving reference map..');
                                    })
                                    : LinearProgressLoader('Loading..');
                              }
                          ): Text(''),
                        ]
                    ): CircularProgressLoader('');
                  }),
            )
          ],
        )
      ),
    );
  }
}



_displayDialog(BuildContext context, String authToken, String baseUrl) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: Duration(milliseconds: 500),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Center(
            child: QRCodeScanningPage(authToken: authToken, baseUrl: baseUrl),
          ),
        ),
      );
    },
  );
}

