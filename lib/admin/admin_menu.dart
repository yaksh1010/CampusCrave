import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuViewPage extends StatelessWidget {
  const MenuViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategorySection(category: 'Pizza'),
            CategorySection(category: 'Burger'),
            CategorySection(category: 'Ice-cream'),
            CategorySection(category: 'Salad'),
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String category;

  const CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Food").doc("Category").collection(category).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final List<QueryDocumentSnapshot> foodItems = snapshot.data!.docs;
            int totalFoodItems = foodItems.length;
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalFoodItems,
                  itemBuilder: (context, index) {
                    final foodItem = foodItems[index];
                    return FoodItemTile(foodItem: foodItem);
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Products: $totalFoodItems',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class FoodItemTile extends StatefulWidget {
  final QueryDocumentSnapshot foodItem;

  const FoodItemTile({required this.foodItem});

  @override
  _FoodItemTileState createState() => _FoodItemTileState();
}

class _FoodItemTileState extends State<FoodItemTile> {
  late bool isDisplayed;

  @override
  void initState() {
    super.initState();
    isDisplayed = widget.foodItem['isDisplayed'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.foodItem.id), // Unique key for each dismissible widget
      direction: DismissDirection.endToStart, // Swipe direction
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: AlignmentDirectional.centerEnd,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showConfirmationDialog(context);
      },
      onDismissed: (direction) {
        _deleteItem();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.foodItem['Image']),
          ),
          title: Text(
            widget.foodItem['Name'],
            style: TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            'Price: \₹${widget.foodItem['Price']}',
            style: TextStyle(fontSize: 16),
          ),
          trailing: Switch(
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.black,
            
            value: isDisplayed,
            onChanged: (value) {
              setState(() {
                isDisplayed = value;
              });
              _updateDisplayStatus(value);
            },
          ),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoAlertDialog(
            title: Text('Delete Item'),
            content: Text('Are you sure you want to delete this item?'),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel deletion
                },
              ),
              CupertinoDialogAction(
                child: Text('Delete'),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm deletion
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Delete Item'),
            content: Text('Are you sure you want to delete this item?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel deletion
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm deletion
                },
              ),
            ],
          );
        }
      },
    );
  }

  void _deleteItem() {
    FirebaseFirestore.instance
        .collection("Food")
        .doc("Category")
        .collection(widget.foodItem.reference.parent.id)
        .doc(widget.foodItem.id)
        .delete();
  }

  void _updateDisplayStatus(bool newValue) {
    FirebaseFirestore.instance
        .collection("Food")
        .doc("Category")
        .collection(widget.foodItem.reference.parent.id)
        .doc(widget.foodItem.id)
        .update({'isDisplayed': newValue});
  }
}
