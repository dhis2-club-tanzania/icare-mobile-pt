
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/shared/capture_form_data.dart';
import '/shared/drug_service.dart';
import '/models/drug_response_model.dart';
import '/shared/dropdown_with_search.dart';
import '/stock_taking/qrcode_scanner.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class StockTakingPage extends StatefulWidget {
  final String authToken;
  final String baseUrl;
  StockTakingPage({Key? key, required this.authToken, required this.baseUrl}) : super(key: key);
  @override
  _StockTakingPageState createState() => _StockTakingPageState();
}

class _StockTakingPageState extends State<StockTakingPage> {
  String scannedBarCode = '';
  DataModel selectedItem =DataModel(uuid: '', display: '');
  bool datePickerSet = false;
  String selectedDate = '';
  dynamic drugReferenceTerm = {
    'code': '',
    'conceptSource': ''
  };
  // final formFields = [];
  final expiryDateController = TextEditingController();
  Future<void> _scan() async {
    String? barcode =  await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    // await scanner.scan();
    setState(() {
      scannedBarCode = barcode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            FlatButton(
              onPressed: () =>_scan(),
              child: scannedBarCode == '' ? Center(
                child: Text("SCAN BAR/QR CODE ", style: TextStyle(color: Colors.blue)),
              ) : Center(
                child: FutureBuilder(
                          future: searchDrugs(widget.authToken, widget.baseUrl, scannedBarCode),
                          builder: (BuildContext context,AsyncSnapshot snapshot) {
                            final DataModel drugWithGivenBarCode = snapshot.data[0];
                            return snapshot.hasData ? Column(
                                children: [
                                  Container(
                                    child: snapshot.data.length > 0 ? Center(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget> [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(drugWithGivenBarCode.display, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
                                            // CaptureFormData( headerText: drugWithGivenBarCode.display, formFields: formFields)
                                            Container(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Padding(
                                                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                      child: TextField(
                                                        keyboardType: TextInputType.text,
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            labelText: 'Batch',
                                                            hintText: 'Enter Batch'),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Padding(
                                                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                      child: TextField(
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly,
                                                          ],
                                                          decoration: InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          labelText: 'Qauntity',
                                                          hintText: 'Enter quantity'),
                                                          maxLines: 1,
                                                      ),
                                                    ),
                                                    Padding(
                                                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                      padding: EdgeInsets.symmetric(horizontal: 50),
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            readOnly: true,
                                                            controller: expiryDateController,
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Expiry date',
                                                                hintText: 'Enter expiry date',
                                                                suffixIcon: IconButton(
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      datePickerSet = !this.datePickerSet;
                                                                    });
                                                                  },
                                                                  icon: Icon(Icons.date_range_outlined),
                                                                ),
                                                            ),
                                                            maxLines: 1,
                                                          ),
                                                          datePickerSet ? Padding(
                                                            //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                              padding: EdgeInsets.symmetric(horizontal: 50),
                                                              child: Container(
                                                                child: SfDateRangePicker(
                                                                  onSelectionChanged: _onDateSelectionChanged,
                                                                ),
                                                              )
                                                          ): Text(''),
                                                        ],
                                                      )
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ):
                                    SearchFromOnlineDropDown(searchingText: 'paracetamol', basicAuthToken:widget.authToken, baseUrl: widget.baseUrl, getSelectedItem: (data) => {
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
                                                      return snapshot.hasData ? Text('Successfully saved'): Text('Saving reference map .............');
                                                    })
                                                : Text('Loading .................................');
                                          }
                                        ): Text(''),
                                ]
                            ): Text('Loading ......................................');
                          }),
              ),
            ),
          ],
        )
      ),
    );
  }

  void _onDateSelectionChanged(DateRangePickerSelectionChangedArgs selections) {
    this.expiryDateController.value = expiryDateController.value.copyWith(text: selections.value.toString().substring(0,10),);
    print(selections.value);
    setState(() {
      this.datePickerSet = !this.datePickerSet;
    });
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

