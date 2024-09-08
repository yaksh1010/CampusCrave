import "package:campuscrave/user/user_foodDetail.dart";
import "package:campuscrave/widgets/widget_support.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

class userhome_horizontal extends StatelessWidget {
  const userhome_horizontal({
    super.key,
    required this.fooditemStream,
  });

  final Stream? fooditemStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                        detail: ds["Detail"],
                        image: ds["Image"],
                        name: ds["Name"],
                        price: ds["Price"],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              ds["Image"],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            ds["Name"],
                            style: AppWidget.semiBoldTextFieldStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            ds["Detail"],
                            style: AppWidget.LightTextFieldStyle(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "\₹${ds["Price"]}",
                            style: AppWidget.semiBoldTextFieldStyle(),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
