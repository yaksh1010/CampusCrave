import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  
  final CollectionReference feedbacksCollection = FirebaseFirestore.instance.collection('Feedbacks');

  void submitFeedback() async {
    String name = nameController.text;
    String feedback = feedbackController.text;
    

    if (feedback.isNotEmpty && name.isNotEmpty) {
      await feedbacksCollection.add({
        'name': name,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      feedbackController.clear();
      nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //name
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  hintText: 'Your Name',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20,),
            // Feedback Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  hintText: 'Enter your feedback',
                  border: InputBorder.none,
                ),
                maxLines: 5,
              ),
            ),
            SizedBox(height: 16.0),
            // Name Input Field
            
            
            // Submit Button
            ElevatedButton(
              onPressed: submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
