import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socially/config.dart';
import 'profile_header.dart';
import 'profile_stats.dart';
import 'profile_posts.dart';

class OtherProfileScreen extends StatefulWidget {
  final String userId;

  const OtherProfileScreen({super.key, required this.userId});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  Map<String, dynamic>? userDetails;
  List<dynamic> allFeedPosts = [];
  List<dynamic> testList = [{}];

  @override
  void initState() {
    getUserData(widget.userId);
    fetchFeedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Add action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(4),
              // Space between image and white background
              decoration: BoxDecoration(
                color: ColorResources.UnselectedIconColor, // Background color
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userDetails != null
                      ? NetworkImage(userDetails?['userProfilePic'])
                      : AssetImage("assets/images/profilePic.png")
                          as ImageProvider // Replace with the actual image URL
                  ),
            ),
            SizedBox(height: 10),
            Text(
              userDetails != null ? userDetails!['userName'] : "Loading...",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_pin,
                    color: ColorResources.UnselectedIconColor),
                SizedBox(width: 5),
                Text(
                  userDetails != null ? userDetails!['location'] : "Loading...",
                  style: TextStyle(
                      color: ColorResources.UnselectedIconColor, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person, color: ColorResources.PrimaryColor),
                  label: Text(
                    'Connect',
                    style: TextStyle(color: ColorResources.PrimaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.SelectedIconColor,
                    minimumSize: Size(150, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.message_outlined,
                      color: ColorResources.SelectedIconColor),
                  label: Text(
                    'Message',
                    style: TextStyle(color: ColorResources.SelectedIconColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    minimumSize: Size(150, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 5.0),
                child: Card(
                  color: ColorResources.PrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                  allFeedPosts.isNotEmpty
                                      ? allFeedPosts.length.toString()
                                      : "0",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              Text('Posts',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          height: 60,
                          // Adjust the height according to your design
                          child: VerticalDivider(
                            color: Colors.grey,
                            // Adjust the color to fit your design
                            thickness:
                                1, // Adjust the thickness to fit your design
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                  userDetails != null
                                      ? userDetails!['connections']
                                          .length
                                          .toString()
                                      : "...",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              Text('Connections',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            allFeedPosts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("No posts to show")),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(allFeedPosts.length, (index) {
                        final post = allFeedPosts[index];
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 1.0),
                          child: Container(
                            margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: post['image'] != ""
                                    ? post['image'] != null ? NetworkImage(post['image']) : AssetImage("assets/images/postImg.png") as ImageProvider
                                    : AssetImage("assets/images/postImg.png")
                                        as ImageProvider,
                                // Use imagePaths list
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        );
                      }),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void getUserData(String userId) async {
    var reqBody = {"userId": userId};
    print(userId);

    var response = await http.post(Uri.parse(findUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    print(userId);
    print(response);

    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse);
    setState(() {
      userDetails = jsonResponse["data"];
    });
    print(userDetails);
  }

  void fetchFeedPosts() async {
    print("Fetching feed posts");

    List<String> allUserIds = [widget.userId];
    print(allUserIds);

    var reqBody = {
      "userIds": allUserIds,
    };

    var response = await http.post(Uri.parse(fetchPostApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    var jsonResponse = jsonDecode(response.body);
    List<dynamic> allPosts = jsonResponse["data"];

    if(allPosts[0]['userName'] == null) {
      setState(() {
        allFeedPosts = [];
      });
    } else {
      setState(() {
        allFeedPosts = allPosts;
      });
    }

    print("Fetched feed posts: $allFeedPosts Next: $testList");
  }
}
