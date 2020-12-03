import 'package:crudfulapp/view/tasks.dart';
import 'package:flutter/material.dart';

//Sedat Gülmen tarafından Crudful.com için yazılmıştır
// 2020

//It was coded for Crudful.com by Sedat Gülmen.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crudful Task App',
      debugShowCheckedModeBanner: false,
      home: TasksPage(),
    );
  }
}
