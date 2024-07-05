import 'package:flutter/material.dart';
import 'package:socially/pages/CommunitiesScreen.dart';
import 'package:socially/pages/LoginScreen.dart';
import 'package:socially/pages/ProfileScreen.dart';

import '../services/firebase_authentication.dart';
import 'AddLocationScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthenticationService _authService = AuthenticationService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                        TextSpan(text: 'Create Your\n'),
                        TextSpan(
                            text: 'Account ',
                            style: TextStyle(color: Color(0xFF618F00))),
                        TextSpan(text: 'Now!'),
                      ],
                    ),
                  ),
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
                    controller: _emailController,
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
                      hintText: 'Email',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.email,
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
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextFormField(
                    controller: _passwordController,
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
                      hintText: 'Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.key,
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
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextFormField(
                    controller: _confirmPasswordController,
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
                      hintText: 'Confirm Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.key,
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
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var fullName = _fullNameController.text;
                          var email = _emailController.text;
                          var password = _passwordController.text;

                          var user =
                          await _authService.registerWithEmailPassword(
                              email, password, fullName);

                          if (user != null) {
                            var tempUser = [user.uid, fullName, email, password];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddLocation(userData: tempUser),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Registration failed')),
                            );
                          }
                        }
                      },
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
}
