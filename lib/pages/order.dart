import 'dart:async';
import 'dart:math';
import 'package:campuscrave/pages/success.dart';
import 'package:campuscrave/services/database.dart';
import 'package:campuscrave/services/shared_pref.dart';
import 'package:campuscrave/widgets/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class Order1 {
  late String order_no;

  Order1() {
    var random = Random();
    order_no = 'order_${random.nextInt(100)}';
  }
}

class _OrderState extends State<Order> {
  String? id;
  int total = 0;
  var random = Random();
  //var order_no = 0;
  var _razorpay = Razorpay();

  void startTimer() {
    Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.to(Success());
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  //really needed ??
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  total = total + int.parse(ds["Total"]);
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Decrement action
                                  //  _decrementQuantity(ds["Name"]);
                                  },
                                  icon: Icon(Icons.remove),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(ds["Quantity"]),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Increment action
                                  //  _incrementQuantity(ds["Name"]);
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                                Text(
                                  "\₹" + ds["Total"],
                                  style: AppWidget.semiBoldTextFieldStyle(),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                // Delete action
                               //_deleteItem(ds["Name"]);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(child: const CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                      "Food Cart",
                      style: AppWidget.HeadTextFieldStyle(),
                    )))),
            const SizedBox(
              height: 20.0,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: foodCart()),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                  Text(
                    "\₹" + total.toString(),
                    style: AppWidget.semiBoldTextFieldStyle(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                //razorpay
                var order = Order1();
                var options = {
                  'key': 'rzp_test_YX11pZyfLyoM43',
                  'amount':(total / 2) * 100, //in the smallest currency sub-unit.
                  'name': 'Canteen',
                  'order': {
                    "id": order.order_no,
                    "entity": "order",
                    "amount_paid": 0,
                    "amount_due": 0,
                    "currency": "INR",
                    "receipt": "Receipt ${Random().nextInt(10)} ",
                    "status": "created",
                    "attempts": 0,
                    "notes": [],
                    "created_at": 1566986570
                  }, // Generate order_id using Orders API
                  'description': 'Quick Food',
                  //'timeout': 60, // in seconds
                  // 'prefill': {
                  //   'contact': '9000090000',
                  //   'email': 'gaurav.kumar@example.com'
                  // }
                };
                _razorpay.open(options);

                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) =>  Success()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: const Center(
                    child: Text(
                  "CheckOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}


//rzp_test_aImtYs22ddJrld - test id

//KXpfHLZFjZPeb4dLgiiO5Qv8 - test secret

//deep razor
// rzp_test_YX11pZyfLyoM43
//ctnB3I8EXIgztmoQjeoru8K0