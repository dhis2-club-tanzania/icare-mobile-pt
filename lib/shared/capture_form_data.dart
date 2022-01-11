import 'package:flutter/material.dart';

class CaptureFormData extends StatefulWidget {
  CaptureFormData({Key? key, required this.headerText, required this.formFields}): super(key: key);
  final String headerText;
  final formFields;
  @override
  _CaptureFormDataState createState() => _CaptureFormDataState();
}


class _CaptureFormDataState extends State<CaptureFormData> {

  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Text(widget.headerText)
      ),
    );
  }
}