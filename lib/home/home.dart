
import 'package:flutter/material.dart';
import 'package:icaremobile/models/location.model.dart';
import 'package:icaremobile/shared/loaders.dart';
import 'package:icaremobile/shared/locations.dart';
import '/stock_taking/stock_taking.dart';



class HomePage extends StatefulWidget {
  final String authToken;
  final String baseUrl;
  final Map<String, dynamic> userInfo;
  final List<LocationModel> storeLocations;
  HomePage({Key? key, required this.authToken, required this.baseUrl, required this.userInfo, required this.storeLocations}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentTitle = 'Stock Taking';
  String currentModuleId = 'stocktaking';
  LocationModel currentLocation = LocationModel(uuid: '', display: '');
  Widget bodyContainer = Text('data');
  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry<LocationModel>> moreMenuItems = [];
    widget.storeLocations.forEach((LocationModel location) => {
      moreMenuItems = [...moreMenuItems,
        PopupMenuItem(
          child: Text(location.display),
          value: location
        )
      ]
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitle),
        actions: [
          Container(
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (LocationModel result) { setState(() { currentLocation = result; }); },
              itemBuilder: (BuildContext context) => moreMenuItems,
            ),
          )
        ],
      ),
      body: Container(
          child: currentLocation.uuid != '' ? StockTakingPage(authToken: widget.authToken, baseUrl: widget.baseUrl, locationDetails: currentLocation):
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('Select Location first', textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                )
              ],
            ),
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

