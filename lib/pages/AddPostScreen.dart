import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(73),
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 10.0),
              child: Text(
                "Add Post",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            backgroundColor: Color(0xCCE1E7DE),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 10.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: Size(30, 35),
                    backgroundColor: ColorResources.SelectedIconColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'about post ...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                  ),

                  textAlign: TextAlign.start,
                  maxLines: null,
                  expands: false,

                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Photo'),
                  onTap: () {
                    // Add your photo selection logic here
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.video_library),
                  title: Text('Video'),
                  onTap: () {
                    // Add your video selection logic here
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.connect_without_contact),
                  title: Text('Connect'),
                  onTap: () {
                    // Add your connect logic here
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
