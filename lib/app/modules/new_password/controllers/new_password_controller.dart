import 'package:absensi_app/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPasswordController.text.isNotEmpty) {
      if (newPasswordController.text != 'password') {
        try {
          String email = auth.currentUser!.email!;
          String password = newPasswordController.text;

          await auth.currentUser!.updatePassword(password);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar(
                "Terjadi kesalahan", "Password harus lebih dari 6 karakter");
          } else if (e.code == 'wrong-password') {
            Get.snackbar("Terjadi kesalahan", "password salah");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Gagal membuat password baru");
        }
      } else {
        Get.snackbar("Terjadi kesalahan", "password wajib diubah");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", 'Form tidak boleh kosong');
    }
  }
}
