import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as store;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nimController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  store.FirebaseStorage storage = store.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  Future<void> updatProfile(String uid) async {
    if (nimController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "name": nameController.text,
          'nim': nimController.text,
        };
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          await storage.ref('$uid/profile.$ext').putFile(file);
          String urlImage =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({
            "profile": urlImage,
          });
        }
        await firestore.collection('users').doc(uid).update(data);
        image = null;
        Get.back();
        Get.snackbar("Success", "Profile anda berhasil di update");
      } catch (e) {
        Get.snackbar(
            "Terjadi kesalahan", "Tidak dapat melakukan update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection('users').doc(uid).update({
        "profile": FieldValue.delete(),
      });

      Get.back();
      Get.snackbar("Success", "Profile berhasil di hapus");
    } catch (e) {
      Get.snackbar("Terjadi kesalahan", "Tidak dapat mengupdate profile");
    }
  }
}
