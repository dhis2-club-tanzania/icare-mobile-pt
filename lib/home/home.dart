
import 'package:flutter/material.dart';
import '/stock_taking/stock_taking.dart';



class HomePage extends StatefulWidget {
  final String authToken;
  final String baseUrl;
  HomePage({Key? key, required this.authToken, required this.baseUrl}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentTitle = 'Stock Taking';
  String currentModuleId = 'stocktaking';
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text(currentTitle),),
      body: Container(
        child: currentModuleId == 'stocktaking' ? StockTakingPage(authToken: widget.authToken, baseUrl: widget.baseUrl): StockTakingPage(authToken: widget.authToken, baseUrl: widget.baseUrl),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130,
              child: DrawerHeader(
                child: Text('Menu'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: Text('Stock Taking'),
              onTap: () {
                setState(() {
                  currentTitle = 'Stock taking';
                  currentModuleId = 'stocktaking';
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

