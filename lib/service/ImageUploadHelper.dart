import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadHelper {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(String filePath) async {
    File file = File(filePath);
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('prescriptions/$fileName');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Failed to upload image: $e");
      return '';
    }
  }
}
