import 'dart:convert';


import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Resources/colorresources.dart';
import '../config.dart';

class AddCommunityScreen extends StatefulWidget {
  const AddCommunityScreen({super.key});

  @override
  State<AddCommunityScreen> createState() => _AddCommunityScreenState();
}

class _AddCommunityScreenState extends State<AddCommunityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String imageUrlFromFirebase = "";

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
        String basename = path.basename(fileName);
        Reference ref = _storage.ref().child('community_images').child('$basename$extension');
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Begin your\n',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: ColorResources.LoginGreen,
        
                        ),
                      ),
                      TextSpan(
                        text: 'Community',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          color: Colors.black,
                          height: 1.2,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
        
        
              ),
              const SizedBox(height: 5),
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8),
              //     child: Image.asset(
              //       "assets/images/community_vector.png",
              //       width: 300,
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed for rounded corners
                            child: Container(
                              height: 160, // Adjust height as needed
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _image != null ? FileImage(_image!) : AssetImage('assets/images/communityImg.png') as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: ColorResources.SecondaryColor,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),
        
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF618F00)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFF618F00), width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Community Name',
                    hintStyle:
                    TextStyle(color: ColorResources.hintColor, fontSize: 18),
                    filled: true,
                    fillColor: Color(0xFFE2E7DE),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
                ),
              ),
        
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: TextFormField(
                  controller: _taglineController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF618F00)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFF618F00), width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Tagline',
                    hintStyle:
                    TextStyle(color: ColorResources.hintColor, fontSize: 18),
                    filled: true,
                    fillColor: Color(0xFFE2E7DE),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid tagline';
                    }
                    return null;
                  },
                ),
              ),
        
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: TextFormField(
                  controller: _aboutController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF618F00)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFF618F00), width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'About Community',
                    hintStyle:
                    TextStyle(color: ColorResources.hintColor, fontSize: 18),
                    filled: true,
                    fillColor: Color(0xFFE2E7DE),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe about the community';
                    }
                    return null;
                  },
                ),
              ),
        
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF618F00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: addCommunity,
                    child: const Text('Create'),
                  ),
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }

  void addCommunity() async {
    var name = _nameController.text;
    var tagline = _taglineController.text;
    var about = _aboutController.text;
    var user = FirebaseAuth.instance.currentUser?.uid.toString();

    var community = {
      "communityName": name,
      "communityCreator": user,
      "members": [],
      "tagline": tagline,
      "rating": ["0"],
      "about": about,
      "communityImage": imageUrlFromFirebase
    };

    var response = await http.post(Uri.parse(communityAddApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(community));

    print(response);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Community Added Succefully')),
    );

    Navigator.pop(context);
  }
}
