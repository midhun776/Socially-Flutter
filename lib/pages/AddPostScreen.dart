import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class AddPostScreen extends StatefulWidget {
  final List<String> userData;

  const AddPostScreen({super.key, required this.userData});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState(userData);
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<String> userData;

  final TextEditingController _captionController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String imageUrlFromFirebase = "none";

  _AddPostScreenState(this.userData);

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
      await _uploadImage(_image!, pickedFile!.name);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage(File image, String fileName) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid.toString();
      if (userId != null) {
        String extension = path.extension(fileName);
        String uniqueId = Uuid().v4();
        Reference ref = _storage
            .ref()
            .child('post_images')
            .child(userId)
            .child('$uniqueId$extension');
        UploadTask uploadTask = ref.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        print('Image URL: $downloadUrl');
        setState(() {
          imageUrlFromFirebase = downloadUrl;
        });
        // You can now save this URL to the Firestore user document or use it directly
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  Future<void> _submitPost() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid.toString();
    String caption = _captionController.text;
    String imageUrl = imageUrlFromFirebase;

    if (userId != null && caption.isNotEmpty) {
      try {
        print("object");
        var response = await http.post(Uri.parse(postAddApi),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'userId': userId,
            'caption': caption,
            'image': imageUrl
          }),
        );

        print("Response"+response.statusCode.toString());
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post created successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create post')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting post: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(73),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
            ),
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
                  onPressed: () {
                    _submitPost();
                  },
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(children: [
                  TextField(
                    controller:_captionController,
                    decoration: InputDecoration(
                      hintText: 'about post ...',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    expands: false,
                  ),
                  SizedBox(height: 20),
                  _image != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              children: [
                                Image.file(
                                  _image!,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ]),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Photo'),
                onTap: () {
                  // Add your photo selection logic here
                  _pickImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
