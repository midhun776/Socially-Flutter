import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socially/Resources/colorresources.dart';
import 'package:socially/pages/AddLocationScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class AddImageScreen extends StatefulWidget {
  final List<String> userData;

  const AddImageScreen({super.key, required this.userData});

  @override
  State<AddImageScreen> createState() => _AddImageScreenState(userData);
}

class _AddImageScreenState extends State<AddImageScreen> {
  List<String> userData;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addPhoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String imageUrlFromFirebase = "";

  _AddImageScreenState(this.userData);

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
        Reference ref = _storage.ref().child('user_images').child('$userId$extension');
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
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 22),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.2),
                      children: [
                        TextSpan(text: 'Set Your\n'),
                        TextSpan(
                            text: 'Profile ',
                            style: TextStyle(color: Color(0xFF618F00))),
                        TextSpan(text: 'Now!'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: _image != null ? FileImage(_image!) : AssetImage('assets/images/profilePic.png') as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
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
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextFormField(
                    controller: _fullNameController,
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
                      hintText: 'Full Name',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.person,
                          color: Color(0xFF618F00),
                        ),
                      ),
                      hintStyle:
                      TextStyle(color: Color(0xFF000000), fontSize: 18),
                      filled: true,
                      fillColor: Color(0xFFE2E7DE),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextFormField(
                    controller: _addPhoneController,
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
                      hintText: 'Phone Number',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.phone_rounded,
                          color: Color(0xFF618F00),
                        ),
                      ),
                      hintStyle:
                      TextStyle(color: Color(0xFF000000), fontSize: 18),
                      filled: true,
                      fillColor: Color(0xFFE2E7DE),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 10) {
                        return 'Please enter Mobile Number Correctly';
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
                      onPressed: _addDataToList,
                      child: const Text('Next'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addDataToList() async {
    if (_formKey.currentState!.validate()) {
      var fullName = _fullNameController.text;
      var phoneNumber = _addPhoneController.text;
      if (fullName.isNotEmpty || phoneNumber.isEmpty){
        userData.add(fullName);
        userData.add(phoneNumber);
        userData.add(imageUrlFromFirebase);

        print("Data" + userData.toString());
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => AddLocation(userData: userData),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill the details!')),
      );
    }
  }
}
