import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'constants.dart';
import 'main.dart';

class Contacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded)),
        title: Text(
          "Contacts",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
