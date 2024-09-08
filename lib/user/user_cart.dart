import 'dart:async';
import 'dart:io'; // Import for platform detection
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:campuscrave/database/database.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/widgets/widget_support.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_success.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class GenerateCode {
  late String code;

  GenerateCode() {
    code = '${Random().nextInt(9999)}';
  }
}

class _OrderState extends State<Order> {
  String? id;
  String? username;
  String? name;
  int total = 0;
  final now = DateTime.now();
  var _razorpay = Razorpay();
  late String orderCode;
  bool isLoading = true; // Add a loading state
  bool? isOpen;

  // List to keep track of dismissed items
  final List<DocumentSnapshot> _dismissedItems = [];
  late Stream foodStream;

  void startTimer() {
    Timer(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    username = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  void ontheload() async {
    try {
      await getthesharedpref();
      foodStream = (await DatabaseMethods().getFoodCart(id!))!;
      setState(() {
        isLoading = false; // Set loading to false once data is loaded
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false; // Set loading to false even if there is an error
      });
      // Optionally, show an error message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    startTimer();
    checkCanteenStatus();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<void> checkCanteenStatus() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('canteen').doc('status').get();
    setState(() {
      isOpen = snapshot['isOpen'];
    });
  }

  Future<void> _deleteItemFromCart(DocumentSnapshot item) async {
    try {
      _dismissedItems.add(item); // Keep track of dismissed items
      total -= int.parse(item["Total"]); // Deduct the item's total from the overall total
      setState(() {}); // Trigger a UI update
      await FirebaseFirestore.instance.collection("Users").doc(id!).collection("Cart").doc(item.id).delete();
    } catch (e) {
      print('Failed to delete item: $e');
    }
  }

  Future<void> _restoreItem(DocumentSnapshot item) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(id!)
          .collection("Cart")
          .doc(item.id)
          .set(item.data() as Map<String, dynamic>);

      setState(() {
        _dismissedItems.remove(item); // Remove item from the temporary list
      });
    } catch (e) {
      print('Failed to restore item: $e');
    }
  }

  Future<bool?> _showConfirmationDialog() async {
    if (Platform.isIOS) {
      return await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text('Confirm Removal'),
              content: Text('Are you sure you want to remove this item from the cart?'),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Remove'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Confirm Removal'),
              content: Text('Are you sure you want to remove this item from the cart?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Remove'),
                ),
              ],
            ),
          ) ??
          false;
    }
  }

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          total = 0; // Reset total before recalculating
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              total += int.parse(ds["Total"]); // Accumulate the total price

              return Dismissible(
                key: ValueKey(ds.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  final result = await _showConfirmationDialog();
                  if (result == true) {
                    await _deleteItemFromCart(ds);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Item removed from cart')),
                    );
                    return true;
                  } else {
                    // Restore the item if cancellation is chosen
                    await _restoreItem(ds);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Item restored')),
                    );
                    return false;
                  }
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
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
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10.0),
                                      Text(
                                        ds["Name"],
                                        style: AppWidget.semiBoldTextFieldStyle(),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "\₹" + ds["Total"],
                                        style: AppWidget.semiBoldTextFieldStyle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min, // Minimize the size of this row
                              children: [
                                
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
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
                                ),
                                
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: const CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: isLoading || isOpen == null
          ? Center(child: CircularProgressIndicator())
          : isOpen == true // Check if the canteen is open
              ? Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight  * 0.07,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                        child: Text(
                          "Food Cart",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                       Padding(
                        padding: EdgeInsets.only(left : 20),
                         child: Text(
                          "If mistaken, swipe to delete and add again!!",
                          style: AppWidget.LightTextFieldStyle(),
                          overflow: TextOverflow.ellipsis,
                                               ),
                       ),
                      SizedBox(height: screenHeight * 0.02,),
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: foodCart(),
                      ),
                      const Spacer(),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Price",
                              style: AppWidget.semiBoldTextFieldStyle(),
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
                          orderCode = '${Random().nextInt(9999)}';
                          var options = {
                            'key': 'rzp_test_YX11pZyfLyoM43',
                            'amount': (total) * 100,
                            'name': 'Canteen',
                            'order': {
                              "id": orderCode,
                              "entity": "order",
                              "amount_paid": 0,
                              "amount_due": 0,
                              "currency": "INR",
                              "receipt": "Receipt ${Random().nextInt(10)}",
                              "status": "created",
                              "attempts": 0,
                              "notes": [],
                              "created_at": 1566986570
                            },
                            'description': 'Quick Food',
                          };
                          _razorpay.open(options);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                          child: const Center(
                            child: Text(
                              "CheckOut",
                              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/sorry.gif",
                        height: 300,
                        width: 300,
                        alignment: Alignment.center,
                      ),
                      const SizedBox(height: 20.0), // Add spacing between the image and the text
                      const Text(
                        "Sorry, Canteen is closed.",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    placeOrder(orderCode);
    StoreOrder(orderCode);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Success(
          userId: id!, // Pass the user ID
          orderCode: orderCode, // Pass the generated order code
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  var code1 = GenerateCode();

  void placeOrder(String orderCode) async {
    if (id != null) {
      var items = <Map<String, dynamic>>[];
      await FirebaseFirestore.instance.collection("Users").doc(id!).collection("Cart").get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          items.add({
            'itemName': doc['Name'],
            'quantity': doc['Quantity'],
            'total': doc['Total'],
          });
        });
      });
      if (items.isNotEmpty) {
        await DatabaseMethods().placeOrder(now, id!, orderCode, total, items, code1.code);
      }
    }
  }

  void StoreOrder(String orderCode) async {
    if (id != null) {
      var Storeitems = <Map<String, dynamic>>[];
      await FirebaseFirestore.instance.collection("Users").doc(id!).collection("Cart").get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          Storeitems.add({
            'itemName': doc['Name'],
            'quantity': doc['Quantity'],
            'total': doc['Total'],
          });
        });
      });
      if (Storeitems.isNotEmpty) {
        await DatabaseMethods().StoreOrder(now, id!, orderCode, total, Storeitems, code1.code);
      }
    }
  }
}
