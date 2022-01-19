


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icaremobile/shared/drug_service.dart';
import 'package:icaremobile/shared/loaders.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StockDataForm extends StatefulWidget {
  final String authToken;
  final String baseUrl;
  final String conceptUuid;
  final String locationUuid;
  StockDataForm({Key? key, required this.authToken, required this.baseUrl, required this.conceptUuid, required this.locationUuid}) : super(key: key);
  @override
  _StockDataFormState createState() => _StockDataFormState();
}

class _StockDataFormState extends State<StockDataForm> {
  final expiryDateController = TextEditingController();
  final batchNoController = TextEditingController();
  final quantityController = TextEditingController();
  final buyingPriceController = TextEditingController();
  final remarksController = TextEditingController();
  bool areSomeFieldsMissing = false;
  bool datePickerSet = false;
  bool savingStock = false;
  String selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    onSave(widget.conceptUuid, batchNoController.text, quantityController.text, expiryDateController.text, buyingPriceController.text, remarksController.text);
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
            'uuid': widget.locationUuid
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

