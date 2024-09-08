import 'package:campuscrave/user/user_foodDetail.dart';
import 'package:campuscrave/database/database.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/widgets/userhome_vertical.dart';
import 'package:campuscrave/widgets/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = true;
  bool? isOpen; // Nullable to handle loading state
  Stream? fooditemStream;
  String? name;

  @override
  void initState() {
    super.initState();
    checkCanteenStatus();
    ontheload();
  }

  Future<void> checkCanteenStatus() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('canteen').doc('status').get();
    setState(() {
      isOpen = snapshot['isOpen'];
    });
  }

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  ontheload() async {
    fooditemStream = await DatabaseMethods().getDisplayedFoodItems("Burger");
    getthesharedpref();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return SafeArea(
          child: Scaffold(
            body: isOpen == null
                ? const Center(child: CircularProgressIndicator())
                : isOpen!
                    ? SingleChildScrollView(
                        child: SafeArea(
                          child: Container(
                            height: screenHeight * 1.3,
                            width: screenWidth,
                            margin: const EdgeInsets.only(top: 0.0, left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    name == null
                                        ? const Center(child: CircularProgressIndicator())
                                        : Padding(
                                            padding: EdgeInsets.only(top: screenHeight * 0.03),
                                            child: Text(
                                              "Welcome!!",
                                              style: AppWidget.boldTextFieldStyle(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                    Container(
                                      margin: EdgeInsets.only(right: screenWidth * 0.07, top: screenHeight * 0.03),
                                      padding: EdgeInsets.all(screenWidth * 0.008),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.asset(
                                        "images/nuvLogo.png",
                                        height: screenHeight * 0.07,
                                        width: screenWidth * 0.1,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  "NUV Canteen",
                                  style: AppWidget.HeadTextFieldStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Order beforehand to skip the wait!!",
                                  style: AppWidget.LightTextFieldStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                showItem(screenWidth),
                                SizedBox(height: screenHeight * 0.02),
                                Container(
                                  margin: EdgeInsets.only(right: screenWidth * 0.05),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                                    child: Image.asset("images/home_ordernow.png"),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: userhome_vertical(fooditemStream: fooditemStream),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "images/sorry.gif",
                              height: screenHeight * 0.4,
                              width: screenWidth * 0.8,
                              alignment: Alignment.center,
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            const Text(
                              "Sorry, Canteen is closed.",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }

  Widget showItem(double screenWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          foodCategoryItem("Burger", "images/burger.png", burger, screenWidth),
          SizedBox(width: screenWidth * 0.06),
          foodCategoryItem("Salad", "images/salad.png", salad, screenWidth),
          SizedBox(width: screenWidth * 0.06),
          foodCategoryItem("Ice-cream", "images/ice-cream.png", icecream, screenWidth),
          SizedBox(width: screenWidth * 0.06),
          foodCategoryItem("Pizza", "images/pizza.png", pizza, screenWidth),
          SizedBox(width: screenWidth * 0.0),
        ],
      ),
    );
  }

  Widget foodCategoryItem(String category, String asset, bool isSelected, double screenWidth) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          icecream = category == "Ice-cream";
          pizza = category == "Pizza";
          salad = category == "Salad";
          burger = category == "Burger";
        });
        fooditemStream = await DatabaseMethods().getDisplayedFoodItems(category);
        setState(() {});
      },
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.025),
          ),
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Image.asset(
            asset,
            height: screenWidth * 0.12,
            width: screenWidth * 0.12,
            fit: BoxFit.cover,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
