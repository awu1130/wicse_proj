import 'package:flutter/material.dart';
import 'dart:ui';
import 'registration/home.dart';
import 'registration/signup.dart';
import 'garden/garden.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wicse_proj/medicine/medicine_symptom_mainpage.dart';
import 'package:wicse_proj/medicine_symptom_settings.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginRegisterPage(), // Set the initial screen to LoginRegisterPage
    );
  }
}

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // validates login
  Future<void> _login (BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Send data to the backend
    var response = await http.post(
      Uri.parse('http://localhost:5000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    // Check for successful response
    if (response.statusCode == 201) {
      // Navigate to Garden after signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
      print('Error response: ${response.body}');
    }
  }

  // Button builder for both login and signup buttons
  Widget _buildButton(String text, BuildContext context, {bool isLogin = true}) {
    return ElevatedButton(
      onPressed: () {
        if (isLogin) {
          _login(context);
        } else {
          // navigates to signup page if clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupPage()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // button color
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // padding
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
        fillColor: Colors.white.withOpacity(0.8),
        filled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'garden.jpg', // blurry garden image for background
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          // content on top of the blurred image
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'logo.png', // temp logo - to be replaced with project title
                    height: mq.size.height / 4,
                  ),
                  SizedBox(height: 5), // to reduce space between logo and text
                  Column(
                    children: [
                      Text(
                        "BloomWell",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0, // Larger font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5), // Space between the texts
                      Text(
                        "let's unwind",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0, // Smaller font size
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildTextField('Username', Icons.person, _usernameController),
                  SizedBox(height: 20),
                  _buildTextField('Password', Icons.lock, _passwordController, obscureText: true),
                  SizedBox(height: 30),
                  _buildButton('Login', context),
                  SizedBox(height: 20),
                  _buildButton('Sign Up', context, isLogin: false),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
