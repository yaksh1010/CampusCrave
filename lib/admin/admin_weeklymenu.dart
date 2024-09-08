import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminWeeklyMenu extends StatefulWidget {
  const AdminWeeklyMenu({super.key});

  @override
  State<AdminWeeklyMenu> createState() => _AdminWeeklyMenuState();
}

class _AdminWeeklyMenuState extends State<AdminWeeklyMenu> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isLoading = false;

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> saveImage() async {
    if (selectedImage != null) {
      setState(() {
        isLoading = true;
      });

      String imageId = "image"; // Fixed document ID for replacement

      // Upload the image to Firebase Storage
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("Images").child(imageId);
      UploadTask uploadTask = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      // Save the image URL in Firestore
      await FirebaseFirestore.instance.collection('menu').doc(imageId).set({
        'Image': downloadUrl,
      });

      setState(() {
        selectedImage = null; // Clear the selected image
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Menu saved."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image first."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image"),
        bottom: isLoading
            ? const PreferredSize(
                preferredSize: Size.fromHeight(4.0),
                child: LinearProgressIndicator(),
              )
            : null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            GestureDetector(
              onTap: getImage,
              child: selectedImage == null
                  ? Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                        size: 50,
                      ),
                    )
                  : Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: saveImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
