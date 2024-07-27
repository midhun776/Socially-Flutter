import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/ChatScreen.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class Chatinboxscreen extends StatefulWidget {
  const Chatinboxscreen({super.key});

  @override
  State<Chatinboxscreen> createState() => _ChatinboxscreenState();
}

class _ChatinboxscreenState extends State<Chatinboxscreen> {
  var userId = FirebaseAuth.instance.currentUser?.uid.toString();
  List<Map<String, dynamic>> chatList = [];

  final List<String> chatcategories = [
    "All Chats",
    "People",
    "Communities",
  ];

  int selectedIndex = 0; // Initialize with 0 indicating first category is selected
  int selectedChatIndex = -1; // Initialize with -1 indicating no chat selected

  @override
  void initState() {
    super.initState();
    if (userId != null) {
      getUserData(userId!);
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
              height: 43, // Adjust height to fit the text containers
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: chatcategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index; // Update selected index on tap
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? ColorResources.SecondaryColor // Change to desired color when selected
                            : ColorResources.PrimaryColor, // Original color
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          chatcategories[index],
                          style: TextStyle(
                            color: selectedIndex == index ? Colors.white : Colors.black,
                          ),
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
              color: Colors.white, // Set the background color to white
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChatIndex = index; // Update selected chat index on tap
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chatscreen(chatDetails: chatList[index])),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedChatIndex == index
                            ? ColorResources.ContainerColor // Change to desired color when selected
                            : Colors.white, // Original color
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 30,
                                  backgroundImage: chatList[index]['profileImage'] != null
                                      ? NetworkImage(chatList[index]['profileImage'])
                                      : AssetImage("assets/images/profilePic.png") as ImageProvider
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chatList[index]['name'],
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

  void getUserData(String userId) async {
    var reqBody = {"userId": userId};
    var response = await http.post(Uri.parse(findUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);
    var userDetails = jsonResponse["data"];
    var userChats = userDetails?["chats"];

    if (userChats != null) {
      for (var chat in userChats) {
        fetchChatDetails(chat);
      }
    }
  }

  void fetchChatDetails(String userId) async {
    var response = await http.post(Uri.parse(findUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}));

    var chatDetails = jsonDecode(response.body)["data"];
    setState(() {
      chatList.add({
        "connectID": chatDetails["userID"],
        "name": chatDetails["userName"],
        "profileImage": chatDetails["userProfilePic"], // Assuming the profile image URL is available
        "content": "Recent message preview", // Placeholder for recent message preview
        "messages": 0, // Placeholder for unread messages count
        "timestamp": "Just now", // Placeholder for last message timestamp
      });
    });
    print(chatList);
  }
}
