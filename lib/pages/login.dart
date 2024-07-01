import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socially/pages/profile/otherprofile_screen.dart';
import 'package:socially/Resources/colorresources.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.PrimaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),




              Text(
                'Sign in to your account',
                style: TextStyle(fontSize: 18, color: ColorResources.SecondaryColor),
              ),
              SizedBox(height: 30),
              Center(
                child: Image.asset(
                  'assets/images/loginBG.png', // Replace with your asset
                  height: 200,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorResources.ContainerColor,
                  prefixIcon: Icon(Icons.email, color: ColorResources.SelectedIconColor),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorResources.ContainerColor,
                  prefixIcon: Icon(Icons.lock, color: ColorResources.SelectedIconColor),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: ColorResources.SecondaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: ColorResources.SecondaryColor),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text('Remember me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherProfileScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: ColorResources.SecondaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 150,vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: ColorResources.PrimaryColor),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  'Or Login with',
                  style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('assets/images/apple.png'), // Replace with your asset
                    iconSize: 30,
                    onPressed: () {},
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    icon: Image.asset('assets/images/google.png'), // Replace with your asset
                    iconSize: 30,
                    onPressed: () {},
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    icon: Image.asset('assets/images/facebook.png'), // Replace with your asset
                    iconSize: 30,
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ",style: TextStyle(fontWeight: FontWeight.bold),),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Register',
                      style: TextStyle(color: ColorResources.SecondaryColor,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
