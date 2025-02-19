import 'package:coffee_tracker/view/encode_plants.dart';
import 'package:coffee_tracker/view/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore CRUD',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
