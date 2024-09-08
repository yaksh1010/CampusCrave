import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminFeedbacks extends StatefulWidget {
  const AdminFeedbacks({Key? key}) : super(key: key);

  @override
  _AdminFeedbacksState createState() => _AdminFeedbacksState();
}

class _AdminFeedbacksState extends State<AdminFeedbacks> {
  late Stream<QuerySnapshot> feedbacksStream;

  @override
  void initState() {
    super.initState();
    feedbacksStream = FirebaseFirestore.instance.collection("Feedbacks").orderBy('timestamp', descending: true).snapshots();
  }

  String formatDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

 Future<bool?> _showDeleteConfirmationDialog(BuildContext context, DocumentSnapshot feedback) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoAlertDialog(
            title: Text('Delete Feedback'),
            content: Text('Are you sure you want to delete this feedback?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                isDestructiveAction: true,
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Delete Feedback'),
            content: Text('Are you sure you want to delete this feedback?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedbacks',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: feedbacksStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Feedbacks found'),
            );
          }

          Map<String, List<DocumentSnapshot>> groupedFeedbacks = {};
          for (var doc in snapshot.data!.docs) {
            DateTime timestamp = (doc['timestamp'] as Timestamp).toDate();
            String date = formatDate(timestamp);
            if (!groupedFeedbacks.containsKey(date)) {
              groupedFeedbacks[date] = [];
            }
            groupedFeedbacks[date]!.add(doc);
          }

          List<String> sortedDates = groupedFeedbacks.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              String date = sortedDates[index];
              List<DocumentSnapshot> feedbacks = groupedFeedbacks[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey[700], thickness: 1.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Color.fromARGB(255, 103, 160, 225),
                    child: Text(
                      date,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Divider(color: Colors.grey[700], thickness: 1.0),
                  ...feedbacks.map((feedback) {
                    DateTime timestamp = (feedback['timestamp'] as Timestamp).toDate();
                    return Dismissible(
                      key: Key(feedback.id),
                      direction: DismissDirection.endToStart,
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
                        bool? shouldDelete = await _showDeleteConfirmationDialog(context, feedback);
                        if (shouldDelete == true) {
                          await FirebaseFirestore.instance.collection('Feedbacks').doc(feedback.id).delete();
                          return true; // Dismiss the item from the list
                        } else {
                          return false; // Keep the item in the list
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${feedback['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Feedback: ${feedback['feedback']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Time: ${formatTime(timestamp)}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
