import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  final User user;
  const UploadImage({Key? key, required this.user}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar('No file selected', Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${widget.user.uid}/images')
        .child('post_$postID');
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();

    await firebaseFirestore
        .collection('tradesmen')
        .doc(widget.user.uid)
        .collection('images')
        .doc('profile_image')
        .set({'downloadURL': downloadURL}).whenComplete(() =>
            showSnackBar('Image Uploaded Successfully', Duration(seconds: 1)));
  }

  //snackbar for showing errors
  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Upload Image'),
                  const SizedBox(height: 10),
                  Expanded(
                      flex: 4,
                      child: Container(
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _image == null
                                    ? const Center(
                                        child: Text('No Image Selected'),
                                      )
                                    : Image.file(_image!)),
                            ElevatedButton(
                                onPressed: () {
                                  imagePickerMethod();
                                },
                                child: Text('Select Image')),
                            ElevatedButton(
                                onPressed: () {
                                  if (_image != null) {
                                    uploadImage();
                                  } else {
                                    showSnackBar('Select Image First',
                                        Duration(milliseconds: 400));
                                  }
                                },
                                child: Text('Upload Image')),
                          ],
                        )),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
