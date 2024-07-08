import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class Chatscreen extends StatefulWidget {
  final Map<String, dynamic> chatDetails;

  const Chatscreen({super.key, required this.chatDetails});

  @override
  _ChatscreenState createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  List<Map<String, dynamic>> chatList = [];
  var userId = FirebaseAuth.instance.currentUser?.uid.toString();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? currentUserId;
  late String currentUserName;
  late String receiverUserName;

  DocumentReference? chatDoc = null;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    getCurrentUserData(currentUserId!);
    getReceiverUserData(widget.chatDetails["connectID"]);
    getOrCreateChat();
  }

  Future<void> getOrCreateChat() async {
    var chatsCollection = FirebaseFirestore.instance.collection('chats');
    var chatQuery = await chatsCollection
        .where('participants', arrayContains: currentUserId)
        .get();

    bool chatFound = false;

    for (var doc in chatQuery.docs) {
      var participants = doc['participants'] as List<dynamic>;
      if (participants.contains(widget.chatDetails['connectID'])) {
        chatDoc = doc.reference;
        chatFound = true;
        break;
      }
    }

    if (!chatFound) {
      chatDoc = await chatsCollection.add({
        'participants': [currentUserId, widget.chatDetails['connectID']],
      });
    }

    setState(() {}); // Refresh UI after getting chatDoc
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && chatDoc != null) {
      chatDoc?.collection('messages').add({
        'senderId': currentUserId,
        'text': _controller.text,
        'timestamp': FieldValue.serverTimestamp(),
        'seen': false,
      });

      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.chatDetails['profileImage'] != null
                  ? NetworkImage(widget.chatDetails['profileImage'])
                  : AssetImage('assets/images/profilePic.png') as ImageProvider,
            ),
            SizedBox(width: 10),
            Expanded(  // Wrap Text widget in Expanded
              child: Text(
                widget.chatDetails['name'],
                overflow: TextOverflow.ellipsis, // Add ellipsis
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Handle video call button press
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options button press
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: chatDoc != null
                ? StreamBuilder<QuerySnapshot>(
              stream: chatDoc?.collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var messageData = messages[index].data() as Map<String, dynamic>;
                    var isCurrentUser = messageData['senderId'] == currentUserId;
                    var messageText = messageData['text'];
                    var messageSender = messageData['senderId'];

                    return MessageBubble(
                      msgText: messageText,
                      msgSender: isCurrentUser ? currentUserName : receiverUserName,
                      user: isCurrentUser,
                    );
                  },
                );
              },
            )
                : Center(child: CircularProgressIndicator()),
          ),
          Container(
            color: ColorResources.PrimaryColor,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle_outlined, color: ColorResources.SecondaryColor),
                  onPressed: () {
                    // Handle additional action button press
                  },
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: ColorResources.SecondaryColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getCurrentUserData(String userId) async {
    var reqBody = {"userId": userId};
    var response = await http.post(Uri.parse(findUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);
    var userDetails = jsonResponse["data"];
    setState(() {
      currentUserName = userDetails["userName"];
    });
  }

  void getReceiverUserData(String userId) async {
    var reqBody = {"userId": userId};
    var response = await http.post(Uri.parse(findUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);
    var userDetails = jsonResponse["data"];
    setState(() {
      receiverUserName = userDetails["userName"];
    });
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

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;

  MessageBubble(
      {required this.msgText, required this.msgSender, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? ColorResources.SecondaryColor : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : ColorResources.SecondaryColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
