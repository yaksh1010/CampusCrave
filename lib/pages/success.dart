import "dart:math";
import "package:campuscrave/pages/bottomnav.dart";
import "package:flutter/material.dart";


class Order1 {
  late String order_no;

  Order1() {
    var random = Random();
    order_no = 'Order_${random.nextInt(100)}';
  }
}
var order = Order1();

class Success extends StatelessWidget {
   Success({super.key});

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          
          padding:  EdgeInsets.all(20),

          //column
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Section 1
        
               const Image(
                  image: AssetImage("images/success.gif"),
                  width: 300,
                  height: 400),
              //sectin 2

               const Align(
                alignment: Alignment.center,
                child: Text(
                  "Payment Successful!",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: 20),
               Align(
                  alignment: Alignment.center,
                  child: Text(
                      order.order_no,
                      style: const TextStyle(fontSize: 30))),
               const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "\t\t\t\t\tYour order is being prepared!!! \nShow your order number at counter",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 203, 67, 25),
                      foregroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNav()));
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
      ),
    ));
  }
}
