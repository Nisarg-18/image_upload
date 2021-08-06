import 'package:flutter/material.dart';
import 'package:image_upload/screens/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Uploader',
      theme: ThemeData(primaryColor: Colors.deepPurpleAccent),
      home: HomePage(),
    );
  }
}
