import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socially/pages/ChatInboxScreen.dart';
import 'package:socially/pages/ChatScreen.dart';
import 'package:socially/pages/DashboardScreen.dart';
import 'package:socially/pages/HomeScreen.dart';
import 'package:socially/pages/LoginScreen.dart';
import 'package:socially/pages/TravelCommunityScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
            "assets/images/sociallylogo.png",
            width: 120,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }
}
