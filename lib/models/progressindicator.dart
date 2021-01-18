import 'package:flutter/material.dart';

class Progress extends StatefulWidget {
  static String id='Progress';
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Container(
          child: Center(child: CircularProgressIndicator()),
        ));
  }
}
