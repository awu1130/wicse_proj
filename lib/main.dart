import 'package:flutter/material.dart';
import 'dart:ui'; // for BackdropFilter -- blurry effect
import 'home.dart';
import 'signup.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginRegisterPage(),
    );
  }
}

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // validates login
  void _login(BuildContext context) {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email == 'admin' && password == 'password') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    }
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
                  SizedBox(height: 5), // to reduce space between logo and tet
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
                  _buildTextField('Username', Icons.person, _emailController),
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

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.0,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        hintText: label,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton(String text, BuildContext context, {bool isLogin = true}) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: isLogin ? Color(0xFF6F4F37) : Color(0xFF3E2723), // Soil-like browns
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 1.5,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      ),
    );
  }
}
