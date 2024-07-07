import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:socially/config.dart';
import 'package:socially/pages/DashboardScreen.dart';

class AddLocation extends StatefulWidget {
  final List<String> userData;

  const AddLocation({super.key, required this.userData});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final TextEditingController _addLocationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String tokenForSession = "37465";
  var uuid = Uuid();
  List<dynamic> listForPlaces = [{"description": "Kochi"}, {"description": "Kaloor, Kochi, Kerala, India"}];

  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(9.9312, 76.2673);
  final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(10.8505, 76.2711), // Initial position (Kerala, India)
    zoom: 10,
  );

  void makeSuggestion(String input) async {
    String googlePlacesApiKey = "YOUR_GOOGLE_PLACES_API_KEY"; // Replace with your actual API key
    String groundURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var responseResult = await http.get(Uri.parse(request));
    var ResultData = responseResult.body.toString();
    print("Result: " + ResultData);
    print("Result Status: " + responseResult.statusCode.toString());

    if (responseResult.statusCode == 200) {
      setState(() {
        listForPlaces = jsonDecode(responseResult.body.toString())['predictions'];
      });
    } else {
      throw Exception("Showing Data Failed. Try Again!");
    }
  }

  void onModify() {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(_addLocationController.text);
  }

  @override
  void initState() {
    super.initState();
    _addLocationController.addListener(() {
      onModify();
    });
  }

  void _addLocation() async {
    String addLocation = _addLocationController.text;

    if (addLocation.isNotEmpty) {
      setState(() {
        widget.userData.add(addLocation);
        widget.userData.add(_selectedLocation.latitude.toString());
        widget.userData.add(_selectedLocation.longitude.toString());
      });

      var reqBody = {
        "userID": widget.userData[0],
        "userEmail": widget.userData[1],
        "userPassword": widget.userData[2],
        "userName": widget.userData[3],
        "userPhone": widget.userData[4],
        "userProfilePic": widget.userData[5],
        "posts": "0",
        "chats": [],
        "location": widget.userData[6],
        "latitude": _selectedLocation.latitude.toString(),
        "longitude": _selectedLocation.longitude.toString(),
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

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedLocation = tappedPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: TextFormField(
                  controller: _addLocationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF618F00)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF618F00), width: 1.5),
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
                    hintStyle: TextStyle(color: Color(0xFF000000), fontSize: 18),
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
              Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listForPlaces.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListTile(
                        onTap: () async {
                          List<Location> locations = await locationFromAddress(listForPlaces[index]['description']);
                          print(locations.last.latitude);
                          print(locations.last.longitude);
                          setState(() {
                            final List<String> result = [
                              listForPlaces[index]['description'].toString(),
                              locations.last.latitude.toString(),
                              locations.last.longitude.toString()
                            ];
                            print("My" + result.toString());
                            _selectedLocation = LatLng(double.parse(result[1].toString()), double.parse(result[2].toString()));
                            _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedLocation));
                            _addLocationController.text = listForPlaces[index]['description'];
                          });
                        },
                        title: Text(listForPlaces[index]['description']),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Container(
                  height: 200,
                  child: Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.circular(15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation,
                          zoom: 15.0,
                        ),
                        onTap: _onMapTap,
                        markers: {
                          Marker(
                            markerId: MarkerId('selectedLocation'),
                            position: _selectedLocation,
                            draggable: true,
                            onDragEnd: (newPosition) {
                              setState(() {
                                _selectedLocation = newPosition;
                              });
                            },
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
    );
  }
}
