import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'profile_header.dart';
import 'profile_stats.dart';
import 'profile_posts.dart';

class OtherProfileScreen extends StatelessWidget {
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
            ProfileHeader(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileStats(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfilePosts(),
            )
          ],
        ),
      ),
    );
  }
}
