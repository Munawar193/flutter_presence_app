import 'package:absensi_app/app/shared/colors.dart';
import 'package:absensi_app/app/widgets/app_large_text.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUsersController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  TextEditingController nimController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passAdminController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesPegawai() async {
    if (passAdminController.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        // ignore: unused_local_variable
        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminController.text,
        );

        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: 'password',
        );
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await firestore.collection('users').doc(uid).set(
            {
              "uid": uid,
              "nim": nimController.text,
              "name": nameController.text,
              "email": emailController.text,
              "role": "Mahasiswa",
              "createAt": DateTime.now().toIso8601String(),
            },
          );
          await userCredential.user!.sendEmailVerification();
          nimController.text = '';
          nameController.text = '';
          emailController.text = '';
          await auth.signOut();
          // ignore: unused_local_variable
          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminController.text,
          );
          Get.back();
          Get.back();
          Get.snackbar("Success", 'User berhasil ditambahkan');
          isLoadingAddPegawai.value = false;
        }
        // ignore: avoid_print
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == "weak-password") {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat");
          // ignore: avoid_print
          print('The password provided is too weak');
        } else if (e.code == "email-already-in-use") {
          Get.snackbar("Terjadi Kesalahan", "Email ini sudah terdaftar");
        } else if (e.code == "wrong-password") {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang anda masukan tidak benar");
        } else {
          Get.snackbar("Terjadi Kesalahan", e.code);
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai");
        // ignore: avoid_print
        print(e);
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalah", "Password wajib diisi");
    }
  }

  Future<void> addUsers() async {
    if (nimController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        title: "VALIDASI ADMIN",
        titleStyle:
            GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
        content: Column(
          children: [
            const AppText(
              text: "Masukan passwod admin sebagai validasi!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: passAdminController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          ],
        ),
        actions: [
          SizedBox(
              height: 45,
              width: 130,
              child: OutlinedButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  isLoading.value = false;
                  Get.back();
                },
                child: const AppLargeText(
                  text: 'CANCEL',
                  size: 12,
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w600,
                ),
              )),
          SizedBox(
            height: 45,
            width: 130,
            child: Obx(
              () => TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  backgroundColor: AppColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (isLoadingAddPegawai.isFalse) {
                    await prosesPegawai();
                  }
                  isLoading.value = false;
                },
                child: AppLargeText(
                  text:
                      isLoadingAddPegawai.isFalse ? "ADD USERS" : "LOADING...",
                  size: 12,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
      isLoading.value = false;
    } else {
      Get.snackbar("Terjadi Kesalahan", "Form tidak boleh dikosongkan");
    }
  }
}
