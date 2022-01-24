
import 'package:flutter/material.dart';



class StockStatusPage extends StatefulWidget {
  @override
  _StockStatusPageState createState() => _StockStatusPageState();
}

class _StockStatusPageState extends State<StockStatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
        child: ListView(
          children: [
            Text('Stock status')
          ],
         )
        )
    );
  }
}