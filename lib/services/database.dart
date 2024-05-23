import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campuscrave/services/shared_pref.dart';

class DatabaseMethods {
  get http => null; //can be used for user(not sure)

  // Future<int> getPaymentVolume() async {
  //   try {
  //     final response = await http.get(
  //         'https://api.razorpay.com/v1/payments?from=1593320020&to=1624856020&count=2&skip=1'); // Replace 'your_api_endpoint' with your actual endpoint
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return data['payment_volume'];
  //     } else {
  //       print('Failed to fetch payment volume: ${response.statusCode}');
  //       return 0;
  //     }
  //   } catch (e) {
  //     print("Error fetching payment volume: $e");
  //     return 0;
  //   }
  // }

  Future<List<DocumentSnapshot>> getAllUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    return querySnapshot.docs;
  }

  Future<List<DocumentSnapshot>> getFoodOrders() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('foodOrders').get();
    return querySnapshot.docs;
  }

  Future<void> addUserDetail(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .set(userInfoMap);
    } catch (e) {
      print("Error adding user details: $e");
    }
  }

  Future<void> addFoodItem(
      Map<String, dynamic> userInfoMap, String name) async {
    try {
      await FirebaseFirestore.instance.collection(name).add(userInfoMap);
    } catch (e) {
      print("Error adding food item: $e");
    }
  }

  Future<Stream<QuerySnapshot>?> getFoodItem(String name) async {
    try {
      return FirebaseFirestore.instance.collection(name).snapshots();
    } catch (e) {
      print("Error fetching food items: $e");
      return null;
    }
  }

  Future<void> addFoodToCart(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .collection('Cart')
          .add(userInfoMap);
    } catch (e) {
      print("Error adding food to cart: $e");
    }
  }

  Future<Stream<QuerySnapshot>?> getFoodCart(String id) async {
    try {
      return FirebaseFirestore.instance
          .collection("Users")
          .doc(id)
          .collection("Cart")
          .snapshots();
    } catch (e) {
      print("Error fetching food cart: $e");
      return null;
    }
  }

  Future<int> getTotalUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      return querySnapshot.size;
    } catch (e) {
      print("Error fetching total users: $e");
      return 0;
    }
  }

  Future<void> placeOrder(String userId, String orderNumber, int totalAmount,
      List<Map<String, dynamic>> items, String code) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderNumber)
          .set({
        'userId': userId,
        'totalAmount': totalAmount,
        'items': items,
        //'OrderID' : code, // Add items array to the order document
        // Add more order details as needed
      });

      // Move items from cart to FinalOrders collection
      await moveCartItemsToFinalOrders(userId,  code);
    } catch (e) {
      print('Error placing order: $e');
      // Handle error accordingly
    }
  }

  Future<Stream<QuerySnapshot>?> getDisplayedFoodItems(String name) async {
    try {
      return FirebaseFirestore.instance
          .collection(name)
          .where('isDisplayed', isEqualTo: true)
          .snapshots();
    } catch (e) {
      print("Error fetching displayed food items: $e");
      return null;
    }
  }

  // Function to move items from cart to FinalOrders collection
  Future<void> moveCartItemsToFinalOrders(String userId,String code) async {
    try {
      // Get cart items
      QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Cart")
          .get();

      // Create a new document in FinalOrders collection for each cart item
      for (QueryDocumentSnapshot cartDoc in cartSnapshot.docs) {
        await FirebaseFirestore.instance.collection("FinalOrders").add({
          'userId': userId,
          'itemName': cartDoc['Name'],
          'quantity': cartDoc['Quantity'],
          'total': cartDoc['Total'],
          'OrderID' : code,
          // Add more fields as needed
        });
      }

      // Clear the user's cart after moving items to FinalOrders
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("Cart")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      print("Cart items moved to FinalOrders successfully");
    } catch (e) {
      print("Error moving cart items to FinalOrders: $e");
    }
}

}