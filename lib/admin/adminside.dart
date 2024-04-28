// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// class AdminSide extends StatelessWidget {
//   const AdminSide({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const CircleAvatar(
//                 radius: 30,
//               ),
//               const SizedBox(
//                 height: 12.0,
//               ),
//               const Text(
//                 "Yesha Barot",
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//               const Text(
//                 "yesha@gmail.com",
//                 style: TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//               GridView.builder(
//                 shrinkWrap: true,
//                 primary: false,
//                 padding: const EdgeInsets.only(top: 12.0),
//                 itemCount: _dashboardItem.length,
//                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                   maxCrossAxisExtent: 200, // Change to adjust grid item width
//                   mainAxisSpacing: 10.0,
//                   crossAxisSpacing: 10.0,
//                   childAspectRatio: 1.0, // Adjust aspect ratio if needed
//                 ),
//                 itemBuilder: (context, index) {
//                   return _buildGridItem(
//                     _dashboardItem[index]['title'],
//                     _dashboardItem[index]['Subtitle'],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGridItem(String title, String subtitle) {
//     return Card(
//       child: Container(
//         color: const Color.fromARGB(255, 226, 64, 78).withOpacity(0.5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(title),
//             Text(subtitle),
//           ],
//         ),
//       ),
//     );
//   }

//   static final List<Map<String, dynamic>> _dashboardItem = [
//     {
//       "title": "400",
//       "Subtitle": "Users",
//     },
//     {
//       "title": "5",
//       "Subtitle": "Categories",
//     },
//     {
//       "title": "\$600",
//       "Subtitle": "Earning",
//     },
//     {
//       "title": "12",
//       "Subtitle": "Pending Order",
//     },
//     {
//       "title": "5",
//       "Subtitle": "Completed Order",
//     },
//     {
//       "title": "2",
//       "Subtitle": "Cancel Order",
//     },
//     {
//       "title": "5",
//       "Subtitle": "Delivery Order",
//     },
//   ];
// }
