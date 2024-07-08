import 'package:flutter/material.dart';
import 'package:socially/pages/AddImageScreen.dart';
import 'package:socially/pages/DashboardScreen.dart';
import 'package:socially/pages/HomeScreen.dart';
import '../Resources/colorresources.dart';
import '../services/firebase_authentication.dart';
import 'AddLocationScreen.dart';
import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  bool _isRememberMeChecked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome Back!\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            color: Colors.black,
                            height: 1.2,
                            letterSpacing: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign in to your account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: ColorResources.LoginGreen,

                          ),
                        ),
                      ],
                    ),
                  ),


                ),
                const SizedBox(height: 5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(
                      "assets/images/login_image.png",
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextFormField(
                    controller:_emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorResources.LoginGreen),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorResources.LoginGreen,width: 1.5,),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Email',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.person,
                          color: ColorResources.LoginGreen,
                        ),
                      ),
                      hintStyle:
                      TextStyle(color: Color(0xFF000000), fontSize: 18),
                      filled: true, // This sets the background color
                      fillColor: ColorResources.LoginWhite,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorResources.LoginGreen),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorResources.LoginGreen,width: 1.5,),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(
                          Icons.key,
                          color: ColorResources.LoginGreen,
                        ),
                      ),
                      hintStyle: TextStyle(color: Color(0xFF000000),fontSize: 18),
                      filled: true, // This sets the background color
                      fillColor: ColorResources.LoginWhite,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isRememberMeChecked,
                          onChanged: (value) {
                            setState(() {
                              _isRememberMeChecked = value!;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: ColorResources.LoginGreen,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ColorResources.PrimaryColor, backgroundColor: ColorResources.LoginGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(fontSize: 16),
                        // minimumSize: const Size(150, 50),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var email = _emailController.text;
                          var password = _passwordController.text;

                          var user =
                              await _authService.signInWithEmailPassword(
                              email, password);

                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('No User Found')),
                            );
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Or Sign up With",
                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await _authService.loginWithGoogle();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddImageScreen(userData: [],)),
                                );
                              },
                              child: Image.asset('assets/images/google.png',
                                height: 40, width: 40,
                              ),
                            ),
                            const SizedBox(width: 33),
                            GestureDetector(
                              onTap: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddLocation(userData: [],)),
                                );
                              },
                              child: Image.asset('assets/images/facebook.png',
                                height: 40, width: 40,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?\t",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const RegisterScreen()),
                                );
                              },
                              child: const Text(
                                'Register ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF618F00),
                                  height: 1.5,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}