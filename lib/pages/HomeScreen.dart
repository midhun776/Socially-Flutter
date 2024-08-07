import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:socially/config.dart';
import 'package:socially/pages/ChatInboxScreen.dart';
import 'package:socially/pages/DashboardScreen.dart';
import 'package:socially/pages/NotificationScreen.dart';
import 'package:http/http.dart' as http;
import 'package:socially/pages/profile/otherprofile_screen.dart';

import '../Resources/colorresources.dart';
import '../custom_icons_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userId = FirebaseAuth.instance.currentUser?.uid.toString();
  List<dynamic> userConnection = [];
  Map<String, dynamic>? userDetails;
  List<dynamic> allFeedPosts = [];
  List<dynamic> userFeedPosts = [];

  @override
  void initState() {
    super.initState();
    print("hi");
    getUserData(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const NotificationScreen()));
                },
                icon: Icon(
                  CustomIcons.vector,
                  color: ColorResources.SelectedIconColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(
                  CustomIcons.chaticon,
                  color: ColorResources.SelectedIconColor,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatinboxscreen
                    ()));
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 26.0, top: 10.0),
                  child: Text(
                    "Write a Feed",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 26.0, top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/mkbhd.jpeg'),
                        radius: 22.0,
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "What's Happening?",
                                hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, top: 8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(onPressed: () {}, icon: Icon(CustomIcons.vector__1_)),
                            IconButton(onPressed: () {}, icon: Icon(CustomIcons.vector__2_)),
                            IconButton(onPressed: () {}, icon: Icon(CustomIcons.vector__3_)),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getUserData(userId!);
                          },
                          child: Text(
                            "Post",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.SelectedIconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 26.0, top: 10.0),
                  child: Text(
                    "Timeline",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 1.0),
                allFeedPosts.isEmpty
                    ? Column(
                      children: [
                        Center(child: CircularProgressIndicator()),
                        SizedBox(height: 10,),
                        Text("Nothing to show!")
                      ],
                    )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allFeedPosts.length,
                  itemBuilder: (context, index) {
                    final post = allFeedPosts[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                            color: ColorResources.SelectedIconColor,
                            width: 2,
                          ),
                        ),
                        margin: EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if(post['userID'] != userId) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfileScreen(userId: post['userID'],)));
                                } else {
                                  setState(() {
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0, top: 15.0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(post['userProfilePic']),
                                      radius: 22.0,
                                    ),
                                  ),
                                   SizedBox(width: 14.0),
                                  Text(
                                    post['userName'],
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: post['image'] != ""
                                  ? Image.network(post['image'])
                                  : Container(),
                            ),
                            // SizedBox(height: 15.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0,bottom: 8.0),
                              child: Container(

                                child: Text(post['caption']),
                              ),
                            ),




                            // Padding(
                            //   padding: const EdgeInsets.symmetric(),
                            //   child: Container(
                            //     padding: const EdgeInsets.only(left: 2.0),
                            //     child: Text(post['caption']),
                            //   ),
                            // ),


                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,bottom: 3.0),
                              child: Row(
                                children: [
                                  IconButton(onPressed: () {
                                    print(post["image"]);}, icon: Icon(CustomIcons.vector__4_)),
                                  Text("5"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getUserData(String userId) async {
    var reqBody = {
      "userId": userId
    };
    print(userId);

    var response = await http.post(Uri.parse(findUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    print(userId);
    print(response);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    userDetails = jsonResponse["data"];
    setState(() {
      userConnection = userDetails?.remove("connections");
    });
    print(userConnection);
    var userChats = userDetails?.remove("chats");
    print(userConnection);
    print(userDetails);

    fetchFeedPosts();
  }

  void fetchFeedPosts() async {
    print("Fetching feed posts");

    List<String> allUserIds = [userId!, ...userConnection];
    print(allUserIds);

    var reqBody = {
      "userIds": allUserIds,
    };

    var response = await http.post(Uri.parse(fetchPostApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);
    List<dynamic> allPosts = jsonResponse["data"];

    print("Posts: $allPosts");

    if(allPosts[0]['userName'] == null) {
      setState(() {
        allFeedPosts = [];
      });
    } else {
      setState(() {
        allFeedPosts = allPosts;
      });
    }

    print("Fetched feed posts: $allFeedPosts");
  }
}
