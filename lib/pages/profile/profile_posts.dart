import 'package:flutter/material.dart';

class ProfilePosts extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/post1.jpg',
    'assets/images/post2.jpeg',
    'assets/images/post3.jpeg',
    'assets/images/post4.jpeg',
    'assets/images/post5.jpeg',
    'assets/images/post3.jpeg',
    'assets/images/post5.jpeg',
    'assets/images/post1.jpg',
    'assets/images/post5.jpeg',
    'assets/images/post2.jpeg'
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(imagePaths.length, (index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 1.0),
          child: Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePaths[index]), // Use imagePaths list
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.zero,
            ),
          ),
        );
      }),
    );
  }
}
