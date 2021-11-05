import 'package:flutter/material.dart';
import 'mainpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Currency Converter",
      home: Home(),
    );
  }
}
