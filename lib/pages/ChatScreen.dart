import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        backgroundColor: Colorresources.PrimaryColor,
        title: Text(
        "Recent Chats",
        style: TextStyle(color: Colors.black),
    ),
    leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
    // Action to be performed on arrow button press
    Navigator.pop(context);
    },
    ),
        ),
    );
  }
}
