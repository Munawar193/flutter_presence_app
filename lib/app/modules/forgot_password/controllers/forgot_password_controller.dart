import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailController.text);

        emailController.text = '';

        Get.back();

        Get.snackbar("Success",
            "Berhasil mengirimkan email reset password, coba perikasa email kamu");
      } catch (e) {
        Get.snackbar(
            "Terjadi Kesalahan", 'Tidak dapat mengirim email reset password');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
