
import 'dart:convert';
import 'dart:io';
import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:icaremobile/home/home.dart';
import 'package:icaremobile/shared/loaders.dart';
import 'package:icaremobile/shared/locations.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String address = '';
  String username = '';
  String password =  '';
  final addressController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool failedToLogin = false;
  bool authenticating = false;
  bool isPhoneConnectedToInternet = false;
  bool someParametersMissing =false;
  bool serverNotFound = false;
  bool pingDone = false;
  String createBasicAuthToken(username, password) {
    return 'Basic ' + convert.base64Encode(utf8.encode('$username:$password'));
  }

  login(String basicAuth, String address) async {
    final ping = Ping(address, count: 5);
    ping.stream.listen((event) {
      if (event.error == 'UnknownHost') {
        setState(() {
          pingDone = true;
          serverNotFound = false;
          isPhoneConnectedToInternet = true;
          authenticating = true;
        });
      } else {
        setState(() {
          pingDone = true;
          serverNotFound = true;
        });
      }
    });
    if (!serverNotFound && pingDone) {
      final response = await http.get(
        address + '/openmrs/ws/rest/v1/session?v=custom:(authenticated,user:(privileges:(uuid,name,roles),roles:(uuid,name),userProperties))',headers: <String, String>{'Authorization': basicAuth},
      );
      Map<String, dynamic> responseMap = json.decode(response.body);
      if (responseMap['authenticated']) {
        setState((){
          authenticating = false;
          failedToLogin = false;
        });
        final locationResponse = await getStoreLocations(basicAuth, address, responseMap);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => HomePage(authToken: basicAuth, baseUrl: address, userInfo: responseMap, storeLocations: locationResponse ))
        );
        // return responseMap;
      } else {
        setState((){
          authenticating = false;
          failedToLogin = true;
        });
      }
    }
    // try {
    //   final result = await InternetAddress.lookup(address);
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //   }
    // } on SocketException catch (_) {
    //   isPhoneConnectedToInternet = false;
    // }

  }

  @override
  Widget build(BuildContext context) {
    addressController.value = addressController.value.copyWith(text: 'http://icare.dhis2.udsm.ac.tz',);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 180.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 100,
                      child: Text('iCare Stock Taking', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                  ),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Enter address'),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.only(
                    left: 60, right: 60, top: 15, bottom: 0),
                child: TextField(
                  controller: usernameController,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter username'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 60, right: 60, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordController,
                  decoration: InputDecoration(
                      errorText: failedToLogin ? 'Failed to login': null,
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password')
                ),
              ),
              FlatButton(
                onPressed: (){
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    var basicAuthToken = createBasicAuthToken(usernameController.text, passwordController.text);
                    setState(() {
                      someParametersMissing = addressController.text == '' || usernameController.text == '' || passwordController.text == '' ? true: false;
                    });
                    login(basicAuthToken, addressController.text);
                  },
                  child: !authenticating ? Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ):
                  CircularProgressLoader('Logging in'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              serverNotFound ? Text(address + ' Not found, re-check address or contact IT'): Text(''),
              SizedBox(
                height: 130,
              ),
              Text('New User? Contact IT Administrator')
            ],
          ),
        ),
    );
  }
}


