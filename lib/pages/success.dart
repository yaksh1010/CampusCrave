import 'package:campuscrave/pages/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Success extends StatefulWidget {
  final String userId;
  final String orderCode; // Receive the user ID as a parameter

  const Success({Key? key, required this.userId, required this.orderCode})
      : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  late Stream<QuerySnapshot> ordersStream;

  @override
  void initState() {
    super.initState();
    // Query the FinalOrders collection based on the user's ID
    ordersStream = FirebaseFirestore.instance
        .collection("FinalOrders")
        .where('userId', isEqualTo: widget.userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success'),
      ),
      body: StreamBuilder(
        stream: ordersStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No orders available.'),
            );
          }

          // Only one order is expected, so no need for ListView.builder
          DocumentSnapshot order = snapshot.data!.docs[0];

          String orderCode = order['OrderID'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Section 1

              const Image(
                  image: AssetImage("images/success.gif"),
                  width: 300,
                  height: 350),

              //sectiion 2
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Payment Successful!",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Order ID: ${order['OrderID']}',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
                ),),
                const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "\t\t\t\tYour order is being prepared!!! \n\t\t\t\tShow your OrderID at counter",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 30,),
                  SizedBox(
              height: 50,
              width: double.maxFinite,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 203, 67, 25),
                    foregroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNav()));
                },
                child: const Text(
                  "Return to Home Page",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            
              ]);
            
          
        },
      ),
    );
  }
}
