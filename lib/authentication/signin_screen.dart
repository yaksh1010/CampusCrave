import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:campuscrave/user/user_bottomnav.dart';
import 'package:campuscrave/authentication/login_screen.dart';
import 'package:campuscrave/database/database.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:random_string/random_string.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = "";
  String password = "";
  String name = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Sign out of current Google session

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Signed in
          await SharedPreferenceHelper().saveUserName(user.displayName ?? '');
          await SharedPreferenceHelper().saveUserEmail(user.email ?? '');
          await SharedPreferenceHelper().saveUserId(user.uid);
          await SharedPreferenceHelper.setLoggedIn(true); // Set login state to true

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        } else {
          // Handle sign-in failure
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to sign in with Google'),
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Google'),
        ),
      );
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return; // Only proceed if form is valid
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );

      String userId = randomAlphaNumeric(1000);
      Map<String, dynamic> addUserInfo = {
        "Name": nameController.text,
        "Email": emailController.text,
        "Id": userId,
      };
      await DatabaseMethods().addUserDetail(addUserInfo, userId);
      await SharedPreferenceHelper().saveUserName(nameController.text);
      await SharedPreferenceHelper().saveUserEmail(emailController.text);
      await SharedPreferenceHelper().saveUserId(userId);
      await SharedPreferenceHelper.setLoggedIn(true); // Set login state to true

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Password Provided is too Weak",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Account Already Exists",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/SigninIMG.png",
                width: screenWidth * 0.5,
                height: screenHeight * 0.3,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Get On Board!",
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create your account to start Ordering!",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              signinForm(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("OR"),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    height: screenHeight * 0.07,
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image.asset(
                        "images/Google.png",
                        width: screenWidth * 0.08,
                        height: screenHeight * 0.08,
                      ),
                      onPressed: _signInWithGoogle,
                      label: Text(
                        "Sign-in With Google",
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Already have an account? Log In",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: Colors.blue,
                      ),
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

  Form signinForm(double screenWidth) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Name';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: "Full Name",
              hintText: "Eg. John Doe",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter E-mail';
              }
              return null;
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: "Email",
              hintText: "example@gmail.com",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Password';
              }
              return null;
            },
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.fingerprint),
              labelText: "Password",
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    email = emailController.text;
                    name = nameController.text;
                    password = passwordController.text;
                  });
                  _register();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.04,
                ),
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
             
              child: const Text("Sign Up",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}

