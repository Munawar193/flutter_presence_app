import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isloading = false.obs;

  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePassword() async {
    if (currentController.text.isNotEmpty &&
        newController.text.isNotEmpty &&
        confirmController.text.isNotEmpty) {
      if (newController.text == confirmController.text) {
        isloading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currentController.text);

          await auth.currentUser!.updatePassword(newController.text);

          Get.back();

          Get.snackbar("Success", "Password berhasil diupdate");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar(
                "Terjadi kesalahan", "Password yang anda masukan salah");
          } else {
            Get.snackbar("Terjadi Kesalahan", e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar(
              "Terjadi kesalahan", "Tidak dapat melakukan update password");
        } finally {
          isloading.value = false;
        }
      } else {
        Get.snackbar("Terjadi kesalahan", "Password tidak cocok");
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Form tidak boleh dikosongkan");
    }
  }
}
