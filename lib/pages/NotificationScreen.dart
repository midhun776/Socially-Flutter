import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        leading: Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/images/empty_notifications.png"),
            ),
            Text("Empty Notifications", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorResources.SecondaryColor),),
            Text("We'll notify you when there is something new!", style:  TextStyle(fontSize: 15), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
