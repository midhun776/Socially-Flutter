import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class LocationSearchScreen extends StatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  String tokenForSession = "37465";

  var uuid =Uuid();

  List<dynamic> listForPlaces = [{"description" : "Kochi"},{"description" : "Kaloor, Kochi, Kerala, India",}];

  final TextEditingController _controller = TextEditingController();

  void makeSuggestion(String input) async {
    String googlePlacesApiKey = "AIzaSyDQ2c_pOSOFYSjxGMwkFvCVWKjYOM9siow";
    String groundURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var responseResult = await http.get(Uri.parse(request));
    var ResultData = responseResult.body.toString();
    print("Result: "+ResultData);
    print("Result Status: "+responseResult.statusCode.toString());

    if (responseResult.statusCode == 200) {
      setState(() {
        listForPlaces = jsonDecode(responseResult.body.toString()) ['predictions'];
      });
    } else {
      throw Exception("Showing Data Failed. Try Again!");
    }
  }

  void onModify() {
    if (tokenForSession == null){
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onModify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Kochi", style: TextStyle(fontSize: 15),),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close)
        ),
      ),
      body: Column(
        children: [

          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFFFFFF),
              border: Border.all(
                  color: const Color(0xFF456B1F), width: 2), // Border color
            ),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search your city',
                hintStyle: TextStyle(color: Color(0xFF456B1F)),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF456B1F)),
              ),
            ),
          ),


          Expanded(
              child: ListView.builder(
                itemCount: listForPlaces.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: ListTile(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(listForPlaces[index]['description']);
                        print(locations.last.latitude);
                        print(locations.last.longitude);
                        final List<String> result = [listForPlaces[index]['description'].toString(),locations.last.latitude.toString(),locations.last.longitude.toString()];
                        final name = listForPlaces[index]['description'];
                        print(result);
                        Navigator.pop(context,result);
                      },
                      title: Text(listForPlaces[index]['description']),
                    ),
                  );
                },
              )
          ),
        ],
      ),
    );
  }
}
