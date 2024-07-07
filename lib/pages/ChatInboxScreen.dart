import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/ChatScreen.dart';
import 'package:socially/config.dart'; // Import your config file
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class Chatinboxscreen extends StatefulWidget {
  const Chatinboxscreen({Key? key}) : super(key: key);

  @override
  State<Chatinboxscreen> createState() => _ChatinboxscreenState();
}

class _ChatinboxscreenState extends State<Chatinboxscreen> {
  late Map<String, dynamic> currentUser; // To store current user data
  List<Map<String, dynamic>> chatList = [];

  final List<String> chatcategories = [
    "All Chats",
    "People",
    "Communities",
  ];

  int selectedIndex = 0; // Initialize with 0 indicating the first category is selected
  int selectedChatIndex = -1; // Initialize with -1 indicating no chat selected

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Fetch current user data on widget initialization
    fetchChatData(); // Fetch chat data from backend
  }

  Future<void> fetchCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = {
            'name': user.displayName ?? 'Current User',
            'profileImage': user.photoURL ?? 'assets/images/user1.jpg',
            'uid': user.uid, // Use user.uid to access current user's ID
          };
        });
        print('Current User UID: ${user.uid}');
      } else {
        throw Exception('User not found');
      }
    } catch (error) {
      print('Error fetching current user: $error');
    }
  }

  Future<void> fetchChatData() async {
    try {
      final response = await http.post(
        Uri.parse('$url/findUser'),
        body: {'userId': currentUser['uid']},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chatList = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        throw Exception('Failed to load chat data');
      }
    } catch (error) {
      print('Error fetching chat data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PrimaryColor,
        title: Text(
          "Recent Chats",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action to be performed on search icon press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Container(
              height: 43,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chatcategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? ColorResources.SecondaryColor
                            : ColorResources.PrimaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          chatcategories[index],
                          style: TextStyle(color: selectedIndex == index ? Colors.white : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChatIndex = index;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Chatscreen()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedChatIndex == index
                            ? ColorResources.ContainerColor
                            : Colors.white,
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(currentUser['profileImage']),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    chatList[index]['content'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                chatList[index]['timestamp'],
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              SizedBox(height: 5),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: ColorResources.SecondaryColor,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  '${chatList[index]['messages']}',
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
