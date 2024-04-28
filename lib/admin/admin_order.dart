import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrderPage extends StatefulWidget {
  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCartData() async {
    List<Map<String, dynamic>> cartDataList = [];

    // Fetch orders with status 'pending'
    QuerySnapshot ordersSnapshot = await _firestore
        .collection('Orders')
        .where('Status', isEqualTo: 'pending')
        .get();

    // Iterate over each order document
    for (QueryDocumentSnapshot orderDoc in ordersSnapshot.docs) {
      // Get order data and add it to the list
      cartDataList.add({
        'OrderID': orderDoc.id,
        'UserName': orderDoc.get('UserName'),
        'CartItem': {
          'Name': orderDoc.get('Name'),
          'Quantity': orderDoc.get('Quantity'),
          'Total': orderDoc.get('Total'),
        },
      });
    }

    return cartDataList;
  }

  // Function to mark an order as completed
  void markOrderAsCompleted(String orderId) {
    _firestore.collection('Orders').doc(orderId).update({'Status': 'completed'});
    // Refresh UI to reflect changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Order'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCartData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No pending orders.'),
            );
          }

          List<Map<String, dynamic>> cartDataList = snapshot.data!;

          return ListView.builder(
            itemCount: cartDataList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> cartData = cartDataList[index];
              String orderId = cartData['OrderID'];
              String userName = cartData['UserName'];
              Map<String, dynamic> cartItem = cartData['CartItem'];

              // Display order details
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  title: Text('User Name: $userName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${cartItem['Name']}'),
                      Text('Quantity: ${cartItem['Quantity']}'),
                      Text('Total: ${cartItem['Total']}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Mark order as completed when button is pressed
                      markOrderAsCompleted(orderId);
                    },
                    child: Text('Mark Completed'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminOrderPage(),
  ));
}
