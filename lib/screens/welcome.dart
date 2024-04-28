import "package:campuscrave/admin/admin_bottomnav.dart";
import "package:campuscrave/admin/admin_login.dart";

import "package:campuscrave/screens/login_screen.dart";
import "package:flutter/material.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),

          //column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Section 1
              const Image(
                  image: AssetImage("images/welcome.png"),
                  width: 300,
                  height: 400),
              //sectin 2

              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Welcome New User!",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                ),
              ),
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                      "Skip the wait, Savor the taste, \nOrder with Ease, Dine with Peace!",
                      style: TextStyle(fontSize: 20))),
              const SizedBox(
                height: 70,
              ),
              //section 3
              Column(children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminBottomNav()));
                    },
                    child: const Text(
                      "ADMIN",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                //Signup Button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(119, 25, 134, 230),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      "USER",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    ));
  }
}
