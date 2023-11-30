import 'package:firebseauthentication/Screens/UpdateFirestoreData.dart';
import 'package:firebseauthentication/Screens/firebaseimageUploadPicker.dart';
import 'package:firebseauthentication/Screens/multipleImage.dart';
import 'package:flutter/material.dart';

class FirebaseStorage extends StatefulWidget {
  const FirebaseStorage({super.key});

  @override
  State<FirebaseStorage> createState() => _FirebaseStorageState();
}

class _FirebaseStorageState extends State<FirebaseStorage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ImagePickerUpload()));
            }, child: const Text("Image picker upload ")),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateFirestoreData()));
            }, child: const Text("Update Firestore data ")),
              ElevatedButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => const MultiImageVideo()));
              },child: const Text("Select multiple images")),
          ],
        ),
      ),
    );
  }
}
