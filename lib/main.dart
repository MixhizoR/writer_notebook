import 'package:flutter/material.dart';
import 'package:yazar/view/books.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Books(),
      debugShowCheckedModeBanner: false,
    );
  }
}
