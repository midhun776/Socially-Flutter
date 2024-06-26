import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  String _selectedLocation = 'Kochi';
  List<String> _locations = ['Kochi', 'Thevara', 'Kaloor'];

  // List of friends
  final List<Map<String, String>> _allFriends = [
    {'name': 'Merin Mathew', 'location': 'Thevara, Kochi'},
    {'name': 'Alvin Abraham', 'location': 'Kaloor, Kochi'},
    {'name': 'Kareema', 'location': 'Kaloor, Kochi'},
    {'name': 'Civiya', 'location': 'Thevara, Kochi'},
    {'name': 'Nazim', 'location': 'Edapally, Kochi'},
    {'name': 'Dony', 'location': 'Kaloor, Kochi, Kerala, India'}
  ];

  List<Map<String, String>> _filteredFriends = [];
  late GoogleMapController mapController;

  LatLng _center = const LatLng(9.9312, 76.2673);

  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _filterFriends();
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
          Padding(
            padding: const EdgeInsets.only(top: 54.0, left: 20, bottom: 20),
            child: Row(
              children: [
                Icon(Icons.arrow_back,),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    print("Hi");
                    // List<String> result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSearchPage()));
                    // print("Hoi"+result.toString());
                    // setState(() {
                    //   _selectedLocation = result[0].toString();
                    //   _center = LatLng(double.parse(result[1].toString()), double.parse(result[2].toString()));
                    // });
                    // mapController?.animateCamera(CameraUpdate.newLatLng(_center));
                    // _filterFriends();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 18, color: Color(0xFF456B1F),),
                      SizedBox(width: 3),
                      Text(_selectedLocation, style: TextStyle(color: Color(0xFF456B1F),fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ],
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
}

class NearbyFriendsPopup extends StatelessWidget {
  final List<Map<String, String>> friends;

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
        color: Color(0xFFF6FFEC),
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
                color: Color(0xFFD8EAC1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black.withOpacity(0.5))],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/user${index + 1}.jpg'), // Replace with actual images
                ),
                title: Text(friends[index]['name']!, style: TextStyle(fontWeight: FontWeight.bold),),
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
}