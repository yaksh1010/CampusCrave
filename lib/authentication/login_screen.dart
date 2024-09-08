import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campuscrave/user/user_bottomnav.dart';
import 'package:campuscrave/authentication/signin_screen.dart';
import 'package:campuscrave/database/shared_pref.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool loggedIn = await SharedPreferenceHelper.isLoggedIn();
    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (userCredential.user != null) {
          // Save login state and user information
          await SharedPreferenceHelper.setLoggedIn(true);
          await SharedPreferenceHelper().saveUserEmail(_emailController.text);
          await SharedPreferenceHelper().saveUserId(userCredential.user!.uid);
          await SharedPreferenceHelper().saveUserName(userCredential.user!.displayName ?? '');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * 0.3; // 30% of screen height
    final double imageWidth = screenWidth * 0.8; // 80% of screen width
    final double titleFontSize = screenWidth * 0.09; // 9% of screen width
    final double subtitleFontSize = screenWidth * 0.05; // 5% of screen width
    final double buttonHeight = screenHeight * 0.07; // 7% of screen height
    final double buttonFontSize = screenWidth * 0.05; // 5% of screen width
    final double padding = screenWidth * 0.05; // 5% of screen width

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  image: const AssetImage("images/LoginIMG.png"),
                  width: imageWidth,
                  height: imageHeight,
                ),
                SizedBox(height: screenHeight * 0.03), // 3% of screen height
                Text(
                  "Greetings!!",
                  style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.w600),
                ),
                Text(
                  "Log in to continue",
                  style: TextStyle(fontSize: subtitleFontSize),
                ),
                SizedBox(height: screenHeight * 0.04), // 4% of screen height
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: "Email",
                          hintText: "example@gmail.com",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02), // 2% of screen height
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          labelText: "Password",
                          suffixIcon: IconButton(
                            onPressed: _togglePasswordVisibility,
                            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03), // 3% of screen height
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: buttonHeight * 0.2,
                            horizontal: screenWidth * 0.25,
                          ),
                          backgroundColor: const Color.fromARGB(226, 0, 0, 0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Login", style: TextStyle(fontSize: buttonFontSize)),
                      ),
                      SizedBox(height: screenHeight * 0.03), // 3% of screen height
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(fontSize: subtitleFontSize, color: Colors.blue),
                        ),
                      ),
                    ],
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
