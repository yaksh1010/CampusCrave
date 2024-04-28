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
      body: SingleChildScrollView(
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
          stream: FirebaseFirestore.instance.collection(category).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: totalFoodItems,
                  itemBuilder: (context, index) {
                    final foodItem = foodItems[index];
                    return FoodItemTile(foodItem: foodItem);
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Total Products: $totalFoodItems',
                  style: TextStyle(
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
    return Card(
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
          'Price: \$${widget.foodItem['Price']}',
          style: TextStyle(fontSize: 16),
        ),
        trailing: Switch(
          value: isDisplayed,
          onChanged: (value) {
            setState(() {
              isDisplayed = value;
            });
            _updateDisplayStatus(value);
          },
        ),
      ),
    );
  }

  void _updateDisplayStatus(bool newValue) {
    FirebaseFirestore.instance.collection(widget.foodItem.reference.parent!.id).doc(widget.foodItem.id).update({
      'isDisplayed': newValue,
    });
  }
}
