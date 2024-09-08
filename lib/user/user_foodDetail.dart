import 'package:campuscrave/database/database.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/widgets/widget_support.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String image, name, detail, price;
  Details({super.key, required this.detail, required this.image, required this.name, required this.price});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1, total = 0;
  String? id;

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    total = int.parse(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust the size based on the screen width
    final imageSize = screenWidth * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(imageSize / 2), // Ensure this is a perfect circle
                child: Image.network(
                  widget.image,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      quantity--;
                      total = total - int.parse(widget.price);
                    }
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Text(
                  quantity.toString(),
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                SizedBox(width: screenWidth * 0.05),
                GestureDetector(
                  onTap: () {
                    quantity++;
                    total = total + int.parse(widget.price);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              widget.detail,
              maxLines: 4,
              style: AppWidget.LightTextFieldStyle(),
            ),
            SizedBox(height: screenHeight * 0.05),
            Row(
              children: [
                Text(
                  "Delivery Time",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                SizedBox(width: screenWidth * 0.05),
                const Icon(
                  Icons.alarm,
                  color: Colors.black54,
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  "30 min",
                  style: AppWidget.semiBoldTextFieldStyle(),
                )
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Price",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                    Text(
                      "\₹$total",
                      style: AppWidget.HeadTextFieldStyle(),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    Map<String, dynamic> addFoodtoCart = {
                      "Name": widget.name,
                      "Quantity": quantity.toString(),
                      "Total": total.toString(),
                      "Image": widget.image
                    };
                    await DatabaseMethods().addFoodToCart(addFoodtoCart, id!);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.orangeAccent,
                        content: Text(
                          "Food Added to Cart",
                          style: TextStyle(fontSize: 18.0),
                        )));
                  },
                  child: Container(
                    width: screenWidth * 0.5,
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Add to cart",
                          style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Poppins'),
                        ),
                        SizedBox(width: screenWidth * 0.08),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
