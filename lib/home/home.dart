
import 'package:flutter/material.dart';
import 'package:icaremobile/shared/loaders.dart';
import 'package:icaremobile/shared/locations.dart';
import '/stock_taking/stock_taking.dart';



class HomePage extends StatefulWidget {
  final String authToken;
  final String baseUrl;
  final Map<String, dynamic> userInfo;
  HomePage({Key? key, required this.authToken, required this.baseUrl, required this.userInfo}) : super(key: key);

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
        child: currentModuleId == 'stocktaking' ? Container(
          child: FutureBuilder(
            future: getStoreLocations(widget.authToken, widget.baseUrl, widget.userInfo),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData  ? StockTakingPage(authToken: widget.authToken, baseUrl: widget.baseUrl):
              Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  CircularProgressLoader(''),
                ],
              );
            },
          ),
        ): StockTakingPage(authToken: widget.authToken, baseUrl: widget.baseUrl),
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

