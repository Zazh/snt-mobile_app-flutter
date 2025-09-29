import 'package:flutter/material.dart';
import 'screens/courses_catalog_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learning App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CoursesCatalogScreen(),
    );
  }
}