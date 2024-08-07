import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/LocationSearchScreen.dart';
import 'package:socially/config.dart';
import 'package:http/http.dart' as http;
import 'package:socially/pages/profile/otherprofile_screen.dart';

import 'ChatInboxScreen.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  var userId = FirebaseAuth.instance.currentUser?.uid.toString();
  String _selectedLocation = 'Kochi';
  List<String> _locations = ['Kochi', 'Thevara', 'Kaloor'];

  // List of friends
  List<dynamic> _allFriends = [];

  List<dynamic> _filteredFriends = [];
  late GoogleMapController mapController;

  LatLng _center = const LatLng(9.9312, 76.2673);

  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  void _filterFriends() {
    setState(() {
      _filteredFriends = _allFriends.where((friend) {
        return friend['location']!.contains(_selectedLocation);
      }).toList();

      // Update markers
      _markers.clear();
      for (var friend in _filteredFriends) {
        // Create dummy LatLng for the sake of example
        // In a real application, you'd have real geolocation data
        LatLng friendLocation = _center; // Just for the example
        _markers.add(
          Marker(
            markerId: MarkerId(friend['name']!),
            position: friendLocation,
            infoWindow: InfoWindow(title: friend['name']),
          ),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: ColorResources.LocationBarColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 54.0, left: 30, bottom: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      List<String> result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSearchScreen()));
                      print("Hoi"+result.toString());
                      setState(() {
                        _selectedLocation = result[0].toString();
                        _center = LatLng(double.parse(result[1].toString()), double.parse(result[2].toString()));
                      });
                      mapController?.animateCamera(CameraUpdate.newLatLng(_center));
                      _filterFriends();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Color(0xFF456B1F),),
                        SizedBox(width: 3),
                        Container(width: 250,child: Text(_selectedLocation,maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Color(0xFF456B1F),fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  markers: Set<Marker>.of(_markers),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NearbyFriendsPopup(friends: _filteredFriends),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getAllUsers() async {
    var response = await http.get(Uri.parse(getUsers),
        headers: {"Content-Type": "application/json"});

    var jsonResponse = jsonDecode(response.body);
    List<dynamic> allUsers = jsonResponse["data"];

    setState(() {
      _allFriends = allUsers;
    });

    _filterFriends();
  }
}

class NearbyFriendsPopup extends StatelessWidget {
  final List<dynamic> friends;
  var userId = FirebaseAuth.instance.currentUser?.uid.toString();

  NearbyFriendsPopup({required this.friends});

  @override
  Widget build(BuildContext context) {
    double itemHeight = 85.0; // Adjust the item height as needed
    double maxPopupHeight = itemHeight * 3; // Max height for 3 items
    double popupHeight = itemHeight * friends.length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxPopupHeight, // Maximum height for the container
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true, // Shrink wrap to the size of the content
          padding: EdgeInsets.all(10),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 10), // Space between items
              decoration: BoxDecoration(
                color: ColorResources.UserCardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black.withOpacity(0.5))],
              ),
              child: ListTile(
                onTap: () {
                  if(friends[index]['userID'] != userId) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfileScreen(userId: friends[index]['userID'],)));
                  }
                },
                leading: CircleAvatar(
                  backgroundImage: friends[index]['userProfilePic'] != ""
                      ? NetworkImage(friends[index]['userProfilePic'])
                      : AssetImage("assets/images/profilePic.png") as ImageProvider, // Replace with actual images
                ),
                title: Text(friends[index]['userName']!, style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(friends[index]['location']!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.person_add_alt_outlined),
                      onPressed: () {
                        // Handle message action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.message_outlined),
                      onPressed: () {
                        chatsListUpdate(friends[index]["userID"], context);
                        // Handle add action
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void chatsListUpdate(String friendId, BuildContext context) async {

    var reqBody = {
      "userID": userId,
      "friendId": friendId
    };

    var response = await http.post(Uri.parse(updateChats),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    print(response);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Please wait while we load you chats!')),
    );

    Timer(Duration(seconds: 3),() => Navigator.push(context, MaterialPageRoute(builder: (context) => Chatinboxscreen())));
  }
}