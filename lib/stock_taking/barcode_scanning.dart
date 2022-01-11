
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';



class BarCodeScanningPage extends StatefulWidget {
  @override
  _BarCodeScanningPagePageState createState() => _BarCodeScanningPagePageState();
}

class _BarCodeScanningPagePageState extends State<BarCodeScanningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:<Widget> [
              Container(
                  child: new Row(
                    children: [
                      Container(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                          child: Text("Back",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Text('Barcode scanning here', style: TextStyle(color: Colors.black12, fontSize: 20.0),),
            ],
          ),
        )
    );
  }
}

//
// _scanBarCode() {
//   FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.DEFAULT)!
//       .listen((barcode) {
//           print(barcode);
//     /// barcode to be used
//   });
// }