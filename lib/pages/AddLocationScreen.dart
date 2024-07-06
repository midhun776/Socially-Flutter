import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socially/pages/CommunitiesScreen.dart';
import 'package:socially/pages/DashboardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:socially/config.dart';

class AddLocation extends StatefulWidget {

  final List<String> userData;


  const AddLocation({super.key, required this.userData});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final TextEditingController _addLocationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addLocation() async {
    String addLocation = _addLocationController.text;

    String latitude = "1234567";
    String longitude = "7654321";

    if (addLocation.isNotEmpty) {
      setState(() {
        widget.userData.add(addLocation);
        widget.userData.add(latitude);
        widget.userData.add(longitude);
      });


      var reqBody = {
        "userID" : widget.userData[0],
        "userEmail": widget.userData[1],
        "userPassword": widget.userData[2],
        "userName" : widget.userData[3],
        "userPhone": widget.userData[4],
        "userProfilePic": widget.userData[5],
        "posts": "0",
        "chats": [],
        "location": widget.userData[6],
        "latitude": "123456",
        "longitude": "654321",
      };

      var response = await http.post(Uri.parse(registrationApi),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody));

      print(response);

      _addLocationController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 22),
                  child: Row(
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(text: 'Enter Your\n'),
                            TextSpan(
                              text: 'Location ',
                              style: TextStyle(color: Color(0xFF618F00)),
                            ),
                            TextSpan(text: 'Now!'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextFormField(
                    controller: _addLocationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF618F00)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xFF618F00), width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Location',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.location_pin,
                          color: Color(0xFF618F00),
                        ),
                      ),
                      hintStyle:
                      TextStyle(color: Color(0xFF000000), fontSize: 18),
                      filled: true,
                      fillColor: Color(0xFFE2E7DE),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF618F00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: _addLocation,
                      child: const Text('Register'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}