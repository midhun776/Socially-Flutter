import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/DashboardScreen.dart';
import 'package:socially/pages/HomeScreen.dart';

class Chatinboxscreen extends StatefulWidget {
  const Chatinboxscreen({super.key});

  @override
  State<Chatinboxscreen> createState() => _ChatinboxscreenState();
}

class _ChatinboxscreenState extends State<Chatinboxscreen> {
  final List<String> chatcategories = [
    "All Chats",
    "People",
    "Communities",
  ];

  final List<Map<String, dynamic>> chatList = [
    {
      "name": "Alice",
      "profileImage": "assets/images/user1.jpg", // Asset image
      "content": "Good Night ❤",
      "messages": 3,
      "timestamp": "10:30 PM",
    },
    {
      "name": "Bob",
      "profileImage": "assets/images/user2.jpeg", // Asset image
      "content": "Pls take a look at the images",
      "messages": 5,
      "timestamp": "9:15 PM",
    },
    {
      "name": "Charlie",
      "profileImage": "assets/images/user3.jpeg", // Asset image
      "content": "Let's Meet Tomorrow",
      "messages": 2,
      "timestamp": "8:45 PM",
    },
  ];

  int selectedIndex = -1; // Initialize with -1 indicating no selection
  int selectedChatIndex = -1; // Initialize with -1 indicating no chat selected

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
            // Action to be performed on arrow button press
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action to be performed on search icon press
              // You can navigate to a search screen or open a search dialog
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
              color: Colors.white, // Set the background color to white
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChatIndex = index; // Update selected chat index on tap
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: selectedChatIndex == index
                            ? ColorResources.ContainerColor // Change to desired color when selected
                            : Colors.white, // Original color
                        border: Border.all(color: Colors.grey[300]!, width: 1), // Simple border
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(chatList[index]['profileImage']),
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
}
