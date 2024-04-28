import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartDataPage extends StatefulWidget {
  @override
  _CartDataPageState createState() => _CartDataPageState();
}

class _CartDataPageState extends State<CartDataPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCartData() async {
    List<Map<String, dynamic>> cartDataList = [];

    // Limiting the number of documents fetched to 10
    QuerySnapshot usersSnapshot = await _firestore
        .collection('Users')
        .where('Cart', isNotEqualTo: null)
        .limit(10)
        .get();

    // Fetching 'Cart' subcollections in batches
    List<Future<QuerySnapshot>> futures = [];
    usersSnapshot.docs.forEach((userDoc) {
      futures.add(userDoc.reference.collection('Cart').get());
    });

    // Waiting for all batched queries to complete
    List<QuerySnapshot> cartSnapshots = await Future.wait(futures);

    // Iterating over the results
    for (int i = 0; i < usersSnapshot.docs.length; i++) {
      QueryDocumentSnapshot userDoc = usersSnapshot.docs[i];
      QuerySnapshot cartSnapshot = cartSnapshots[i];

      // Iterate over each document in 'Cart' subcollection
      cartSnapshot.docs.forEach((cartDoc) {
        // Get cart data and add it to the list
        cartDataList.add({
          'UserName': userDoc.get('Name'),
          'CartItem': {
            'Name': cartDoc.get('Name'),
            'Quantity': cartDoc.get('Quantity'),
            'Total': cartDoc.get('Total'),
          },
        });
      });
    }

    return cartDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Data'),
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
              child: Text('No cart data available.'),
            );
          }

          List<Map<String, dynamic>> cartDataList = snapshot.data!;

          return ListView.builder(
            itemCount: cartDataList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> cartData = cartDataList[index];
              String userName = cartData['UserName'];
              Map<String, dynamic> cartItem = cartData['CartItem'];

              // Display cart item details
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
    home: CartDataPage(),
  ));
}
