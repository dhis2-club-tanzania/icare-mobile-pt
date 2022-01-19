import 'package:flutter/material.dart';

class CircularProgressLoader extends StatelessWidget {
  CircularProgressLoader(this.loadingText);
  final String loadingText;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(Colors.blue),
                strokeWidth: 2,
              ),
              height: 15.0,
              width: 15.0,
            ),
            SizedBox(
              height: 15.0,
              width: 15.0,
            ),
            Text(loadingText, style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),)
          ],
        ),
    );
  }
}


class LinearProgressLoader extends StatelessWidget {
  LinearProgressLoader(this.loadingText, {Key? key}) : super(key: key);
  final String loadingText;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
            height: 15.0,
            width: 15.0,
          ),
          SizedBox(
            height: 15.0,
            width: 15.0,
          ),
          Text(loadingText, style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),)
        ],
      ),
    );
  }
}