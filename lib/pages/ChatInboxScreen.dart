import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/ChatScreen.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chatinboxscreen extends StatefulWidget {
  const Chatinboxscreen({super.key});

  @override
  State<Chatinboxscreen> createState() => _ChatinboxscreenState();
}

class _ChatinboxscreenState extends State<Chatinboxscreen> {
  var userId = FirebaseAuth.instance.currentUser?.uid.toString();
  List<Map<String, dynamic>> chatList = [];
  List<Map<String, dynamic>> filteredChatList = []; // For search filtering
  bool isSearching = false;
  String searchQuery = '';

  final List<String> chatcategories = [
    "All Chats",
    "People",
    "Communities",
  ];

  int selectedIndex = 0;
  int selectedChatIndex = -1;

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
        title: isSearching
            ? TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              searchQuery = query;
              filterChats();
            });
          },
        )
            : Text(
          "Recent Chats",
          style: TextStyle(color: Colors.black),
        ),
        leading: isSearching
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              isSearching = false;
              searchQuery = '';
              filteredChatList = chatList;
            });
          },
        )
            : IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchQuery = '';
                  filteredChatList = chatList;
                } else {
                  isSearching = true;
                }
              });
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
              color: Colors.white,
              child: ListView.builder(
                itemCount: filteredChatList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChatIndex = index;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Chatscreen(chatDetails: filteredChatList[index])),
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
                                backgroundImage: filteredChatList[index]['profileImage'] != null
                                    ? NetworkImage(filteredChatList[index]['profileImage'])
                                    : AssetImage("assets/images/profilePic.png") as ImageProvider,
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredChatList[index]['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    filteredChatList[index]['content'],
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
                                filteredChatList[index]['timestamp'],
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
                                  '${filteredChatList[index]['messages']}',
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

  void fetchChatDetails(String receiverId) async {
    var response = await http.post(Uri.parse(findUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": receiverId}));

    var chatDetails = jsonDecode(response.body)["data"];

    var chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    String recentMessage = "";
    Timestamp? lastMessageTimestamp;
    int unreadMessages = 0;

    for (var doc in chatDoc.docs) {
      var participants = doc['participants'] as List<dynamic>;
      if (participants.contains(receiverId)) {
        var messagesQuery = await doc.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messagesQuery.docs.isNotEmpty) {
          var messageData = messagesQuery.docs.first.data();
          recentMessage = messageData['text'] ?? "[Image]";
          lastMessageTimestamp = messageData['timestamp'] as Timestamp?;
          unreadMessages = messagesQuery.docs
              .where((doc) => !doc.data()['seen'])
              .length;
        }
        break;
      }
    }

    String formattedTimestamp = lastMessageTimestamp != null
        ? "${lastMessageTimestamp.toDate().hour}:${lastMessageTimestamp.toDate().minute}"
        : "Just now";

    setState(() {
      chatList.add({
        "connectID": chatDetails["userID"],
        "name": chatDetails["userName"],
        "profileImage": chatDetails["userProfilePic"],
        "content": recentMessage,
        "messages": unreadMessages,
        "timestamp": formattedTimestamp,
      });

      filteredChatList = chatList; // Initialize the filtered list
      // Sort the chatList by timestamp
      chatList.sort((a, b) {
        DateTime aTime = DateTime.parse(a["timestamp"]);
        DateTime bTime = DateTime.parse(b["timestamp"]);
        return bTime.compareTo(aTime); // Sort in descending order
      });
    });
    print(chatList);
  }

  void filterChats() {
    setState(() {
      filteredChatList = chatList.where((chat) {
        return chat['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
            chat['content'].toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }
}
