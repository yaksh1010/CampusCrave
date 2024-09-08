import "package:campuscrave/admin/admin_bottomnav.dart";
import "package:campuscrave/admin/admin_login.dart";
import "package:campuscrave/authentication/login_screen.dart";
import "package:flutter/material.dart";

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.05; // 5% of screen width
    final double imageWidth = screenWidth * 0.8; // 80% of screen width
    final double imageHeight = screenHeight * 0.4; // 40% of screen height
    final double textFontSize = screenWidth * 0.09; // 9% of screen width
    final double subtextFontSize = screenWidth * 0.05; // 5% of screen width
    final double buttonHeight = screenHeight * 0.07; // 7% of screen height
    final double buttonFontSize = screenWidth * 0.05; // 5% of screen width
    final double spacing = screenHeight * 0.02; // 2% of screen height

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(padding),
          child: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.03), // 3% of screen height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Section 1
                Image(
                  image: const AssetImage("images/welcome.png"),
                  width: imageWidth,
                  height: imageHeight,
                ),
                // Section 2
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome New User!",
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Skip the wait, Savor the taste, \nOrder with Ease, Dine with Peace!",
                    style: TextStyle(fontSize: subtextFontSize),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: spacing * 3.5, // Adjusted for spacing
                ),
                // Section 3
                Column(
                  children: [
                    SizedBox(
                      height: buttonHeight,
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminLogin(),
                            ),
                          );
                        },
                        child: Text(
                          "ADMIN",
                          style: TextStyle(fontSize: buttonFontSize),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    // Signup Button
                    SizedBox(
                      height: buttonHeight,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(119, 25, 134, 230),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "USER",
                          style: TextStyle(fontSize: buttonFontSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
