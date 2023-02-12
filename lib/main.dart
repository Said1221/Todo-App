import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/new_screen.dart';
import 'package:todo_app/taskLayout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent,
        )
      ),
      home: tasklayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
