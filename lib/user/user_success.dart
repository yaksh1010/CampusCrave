import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campuscrave/user/user_bottomnav.dart';

class Success extends StatefulWidget {
  final String userId;
  final String orderCode;

  const Success({Key? key, required this.userId, required this.orderCode}) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  //late Stream<QuerySnapshot> ordersStream;
  late String orderCode;

  @override
  void initState() {
    super.initState();
    //ordersStream = FirebaseFirestore.instance.collection("FinalOrders").where('userId', isEqualTo: widget.userId).snapshots();
    orderCode = widget.orderCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Section 1
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      "images/successful.gif",
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8 * 350 / 300, // Aspect ratio
                      fit: BoxFit.cover,
                    ),
                  ),
        
                  // Section 2
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Order Placed!",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Order ID: $orderCode',
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Your order is being prepared!\nShow your OrderID at the counter",
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.w400,
                            //: TextAlign.center,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNav()));
                      },
                      child: const Text(
                        "Return to Home Page",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ));
        }
     
}
