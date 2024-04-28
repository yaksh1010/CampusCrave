import 'package:campuscrave/pages/bottomnav.dart';
import 'package:campuscrave/screens/login_screen.dart';
import 'package:campuscrave/services/database.dart';
import 'package:campuscrave/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = "", password = "", name = "";

  TextEditingController namecontroller = new TextEditingController();

  TextEditingController passwordcontroller = new TextEditingController();

  TextEditingController mailcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar((const SnackBar(
            backgroundColor: Color.fromARGB(255, 22, 210, 50),
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0, color: Colors.black),
            ))));

        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserInfo = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": Id,
        };
        await DatabaseMethods().addUserDetail(addUserInfo, Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserId(Id);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exsists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
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
                image: AssetImage("images/SigninIMG.png"),
                width: 200,
                height: 240),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Get On Board!",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
              ),
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Create your account to start Ordering!",
                    style: TextStyle(fontSize: 20))),
            const SizedBox(
              height: 10,
            ),
            //section 2
            signinForm(),
            //section 3
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("OR"),
                const SizedBox(
                  height: 0,
                ),
                const SizedBox(height: 10),
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
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      "Already have an account? Log In",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ))
              ],
            ),
          ]),
        ),
      ),
    ));
  }

  Form signinForm() {
    return Form(
      key: _formkey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: .0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: namecontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Name';
                }
                return null;
              },
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Full Name ",
                  hintText: "Eg. Deep",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: mailcontroller,
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
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: passwordcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Password';
                }
                return null;
              },
              obscureText: true,
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
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      email = mailcontroller.text;
                      name = namecontroller.text;
                      password = passwordcontroller.text;
                    });
                  }
                  registration();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 40), // function to chnage padding
                    backgroundColor: const Color.fromARGB(226, 0, 0, 0),
                    foregroundColor: Colors.white, // textcolor
                    shape: LinearBorder.bottom() //border color and style
                    ),
                child: const Text("SIGN UP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
