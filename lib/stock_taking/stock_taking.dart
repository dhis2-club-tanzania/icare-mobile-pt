
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icaremobile/models/location.model.dart';
import 'package:icaremobile/shared/loaders.dart';
import '/shared/drug_service.dart';
import '/models/drug_response_model.dart';
import '/shared/dropdown_with_search.dart';
import '/stock_taking/qrcode_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  bool datePickerSet = false;
  String selectedDate = '';
  bool areSomeFieldsMissing = false;
  dynamic drugReferenceTerm = {
    'code': '',
    'conceptSource': ''
  };
  // final formFields = [];
  final expiryDateController = TextEditingController();
  final batchNoController = TextEditingController();
  final quantityController = TextEditingController();
  final buyingPriceController = TextEditingController();
  final remarksController = TextEditingController();
  Future<void> _scan() async {
    String? barcode =  await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
    setState(() {
      scannedBarCode = barcode;
    });
  }

  String ledgerType = '06d7195f-1779-4964-b6a8-393b8152956a';
  String location = '';
  bool savingStock = false;

  @override
  Widget build(BuildContext context) {
    location = widget.locationDetails.uuid;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        child: ListView(
          children: [
            FlatButton(
              onPressed: () =>_scan(),
              child: scannedBarCode == '' ? Center(
                child: Text("SCAN BAR/QR CODE ", style: TextStyle(color: Colors.blue)),
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
                                              height: 20,
                                            ),
                                            Text(widget.locationDetails.display, textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(snapshot.data[0].display, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
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
                                                          controller: batchNoController,
                                                          onTap: updateFormStatus,
                                                          keyboardType: TextInputType.text,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              labelText: 'Batch',
                                                              hintText: 'Enter batch No'),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Padding(
                                                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                        child: TextField(
                                                            controller: quantityController,
                                                            onChanged: (event) {
                                                              updateFormStatus();
                                                            },
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
                                                              onChanged: (event) {
                                                                updateFormStatus();
                                                              },
                                                              decoration: InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                  labelText: 'Expiry date',
                                                                  hintText: 'Enter expiry date',
                                                                  suffixIcon: IconButton(
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        datePickerSet = !datePickerSet;
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
                                                      Padding(
                                                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                        child: TextField(
                                                          controller: buyingPriceController,
                                                          onChanged: (event) {
                                                            updateFormStatus();
                                                          },
                                                          keyboardType: TextInputType.number,
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.digitsOnly,
                                                          ],
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              labelText: 'Buying price',
                                                              hintText: 'Enter buying price'),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Padding(
                                                        //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                        child: TextField(
                                                          controller: remarksController,
                                                          keyboardType: TextInputType.text,
                                                          decoration: InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              labelText: 'Remarks',
                                                              hintText: 'Enter remarks'),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:  EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                        child: Container(
                                                          width: 200,
                                                          height: 50,
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              onSave(snapshot.data[0].concept['uuid'], batchNoController.text, quantityController.text, expiryDateController.text, buyingPriceController.text, remarksController.text);
                                                            },
                                                            child: savingStock ? CircularProgressLoader('Saving data') : Text(
                                                              'Save',
                                                              style: TextStyle(color: Colors.white, fontSize: 18,),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      areSomeFieldsMissing ? Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 50),
                                                        child: Text('Some fields are not set', textAlign: TextAlign.center, style: TextStyle(color: Colors.red),),
                                                      ): Text('')
                                                    ],
                                                  ),
                                                ),
                                            )
                                          ],
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
                            ): CircularProgressLoader('');
                          }),
              ),
            ),
          ],
        )
      ),
    );
  }

  void updateFormStatus() {
    if (quantityController.text != '' && batchNoController.text != '' && expiryDateController.text != '' && buyingPriceController.text != '') {
      setState(() {
        areSomeFieldsMissing = false;
      });
    }
  }

  void _onDateSelectionChanged(DateRangePickerSelectionChangedArgs selections) {
    expiryDateController.value = expiryDateController.value.copyWith(text: selections.value.toString().substring(0,10),);
    print(selections.value);
    setState(() {
      datePickerSet = !datePickerSet;
    });
  }

  void onSave(conceptUuid, batchNo, quantity, expiryDate, buyingPrice, remarks) async {
    if (batchNo == '' || quantity == '' || expiryDate == '' || buyingPrice == '') {
      setState(() {
        areSomeFieldsMissing = true;
      });
    } else {
      setState(() {
        areSomeFieldsMissing = false;
        savingStock = true;
      });
      final dynamic itemResponse = await getBillableItemUsingConceptUuid(widget.baseUrl, widget.authToken, conceptUuid);
      if (itemResponse['uuid'] != null) {
        Map<String, Object> data = {
          'batchNo': batchNo,
          'item': {
            'uuid': itemResponse['uuid']
          },
          'expiryDate': expiryDate + "T00:00:00.000Z",
          'remarks': remarks,
          'ledgerType': {
            'uuid': '06d7195f-1779-4964-b6a8-393b8152956a'
          },
          'location': {
            'uuid': location
          },
          'buyingPrice': int.parse(buyingPrice),
          'quantity': int.parse(quantity)
        };

        final Map<String, Object> response = await saveStock(widget.baseUrl, widget.authToken, data);
        print(response);
        if (response['item'] != null) {
          setState(() {
            savingStock = false;
            quantityController.value =  quantityController.value.copyWith(text: '',);
            expiryDateController.value =  expiryDateController.value.copyWith(text: '',);
            buyingPriceController.value =  buyingPriceController.value.copyWith(text: '',);
            remarksController.value =  remarksController.value.copyWith(text: '',);
          });
        }
      }
    }
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

