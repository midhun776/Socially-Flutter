import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Resources/colorresources.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

void main() {
  runApp(const MaterialApp(
    home: ProfileScreen(),
  ));
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userId = FirebaseAuth.instance.currentUser?.uid.toString();
  Map<String, dynamic>? userDetails;
  List<dynamic> allFeedPosts = [];

  @override
  void initState() {
    super.initState();
    if (userId != null) {
      getUserData(userId!);
      fetchFeedPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.PrimaryColor,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFA0A98C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userDetails != null &&
                            userDetails!['userProfilePic'] != null
                        ? NetworkImage(userDetails!['userProfilePic'])
                        : const AssetImage('assets/images/profilePic.png')
                            as ImageProvider,
                  ),
                ],
              ),
            ),
            // Profile Header
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    userDetails != null
                        ? userDetails!['userName'] ?? 'Unknown'
                        : 'Loading...',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        userDetails != null
                            ? userDetails!['location'] ?? 'Unknown'
                            : 'Loading...',
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.SecondaryColor,
                      // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Stats and Grid View in Column
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Container(
                    decoration: BoxDecoration(
                      color: ColorResources.PrimaryColor,
                      // Background color for stats column
                      borderRadius: BorderRadius.circular(
                          8), // Border radius for stats column
                    ),
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(
                            userDetails?['posts']?.toString() ?? '0', 'Posts'),
                        _buildCustomDivider(), // Custom divider after Posts
                        _buildStatColumn(
                            userDetails?['connections']?.length.toString() ??
                                '0',
                            'Connections'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12), // Space between stats and grid
                  // Grid View for Photos
                  allFeedPosts.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("No posts to show")),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: allFeedPosts.length,
                          // Replace with the actual number of items
                          itemBuilder: (context, index) {
                            final post = allFeedPosts[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                image: DecorationImage(
                                  image: post['image'] != ""
                                      ? NetworkImage(post['image'])
                                      : AssetImage("assets/images/postImg.png")
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }

  Container _buildCustomDivider() {
    return Container(
      width: 2,
      height: 40,
      color: Colors.blueGrey,
      margin: const EdgeInsets.symmetric(horizontal: 8),
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
    var userConnectionCount = userDetails?["connections"]?.length ?? 0;
    var userChats = userDetails?["chats"];
    print(userConnectionCount);
    print(userDetails);
  }

  void fetchFeedPosts() async {
    print("Fetching feed posts");

    List<String> allUserIds = [userId!];
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

    print("Fetched feed posts: $allFeedPosts");
  }
}
