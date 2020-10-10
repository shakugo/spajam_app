import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String text;
  DetailPage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.red,
      ),
    );
  }
}
