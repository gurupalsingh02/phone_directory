// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:phone_directory/contact_page.dart';
import 'package:phone_directory/home_page.dart';
import 'package:phone_directory/store.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/Home",
      routes: {
        "/Home": (context) => HomePage(),
        "/contact": (context) => ContactPage(),
      },
    );
  }
}
