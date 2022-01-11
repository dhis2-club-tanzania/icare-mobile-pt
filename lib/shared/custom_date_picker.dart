import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';


class CustomDatePicker extends StatefulWidget {
  CustomDatePicker({Key? key}): super(key: key);
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}


class _CustomDatePickerState extends State<CustomDatePicker> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: SfDateRangePicker(),
        )
    );
  }
}