import 'package:absensi_app/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isVisible = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            if (passwordController.text == 'password') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              contentPadding: const EdgeInsets.all(10),
              title: "Not verified",
              middleText:
                  "Kamu belum verifikasi akun ini. lakukan verifikasi di email kamu",
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Success",
                          "Email Verifikasi berhasil dikirim ke email anda");
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar("Terjadi kesalahan",
                          "tidak dapat mengirim email verifikasi");
                    }
                  },
                  child: const Text('SEND BACK'),
                )
              ],
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Terjadi kesalahan", "email tidak terdaftar");
          isLoading.value = false;
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi kesalahan", "password salah");
          isLoading.value = false;
        }
      } catch (e) {
        Get.snackbar("Terjadi kesalahan", "Tidak dapat login");
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "email dan password wajib diisi");
    }
  }
}
