import 'package:campuscrave/pages/bottomnav.dart';
import 'package:campuscrave/pages/forgotpassword.dart';
//import 'package:campuscrave/pages/signup.dart';
import 'package:campuscrave/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const BottomNav()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No User Found for that Email",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Wrong Password Provided by User",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),

          //column
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            //Section 1
            const Image(
                image: AssetImage("images/LoginIMG.png"),
                width: 270,
                height: 240),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hello User!",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Login to your Account!",
                    style: TextStyle(fontSize: 20))),
            const SizedBox(
              height: 15,
            ),
            //section 2
            loginform(),

            //section 3
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("OR"),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Image(
                      image: AssetImage("images/Google.png"),
                      width: 30.0,
                      height: 30,
                    ),
                    onPressed: () {},
                    label: const Text(
                      "Sign-in With Google",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      "Don't have an account? Sign up",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ))
              ],
            ),
          ]),
        ),
      ),
    ));
  }

// class of the form created above
  Form loginform() {
    return Form(
      key: _formkey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: useremailcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Email';
                }
                return null;
              },
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Email",
                  hintText: "example@gmail.com",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: userpasswordcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Password';
                }
                return null;
              },
              obscureText: true, // for hiding
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: "Password",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.remove_red_eye),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: const TextButton(
                  onPressed: null,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      email = useremailcontroller.text;
                      password = userpasswordcontroller.text;
                    });
                  }
                  userLogin();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 40), // function to chnage padding
                    backgroundColor: const Color.fromARGB(226, 0, 0, 0),
                    foregroundColor: Colors.white, // textcolor
                    shape: LinearBorder.bottom() //border color and style
                    ),
                child: const Text("LOGIN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
