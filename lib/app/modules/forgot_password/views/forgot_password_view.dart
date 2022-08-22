import 'package:absensi_app/app/widgets/app_large_text.dart';
import 'package:absensi_app/app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/buttom.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLargeText(
              text: 'Reset Password',
              size: 32,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Kami akan mengirimkan email reset password, coba cek folder spam jika email tidak masuk",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return CustomFormInput(
        controller: controller.emailController,
        hintText: "masukan email",
        icon: Icons.email,
        keyboardType: TextInputType.emailAddress,
      );
    }

    Widget buttonSubmit() {
      return Container(
        margin: const EdgeInsets.only(bottom: 20, top: 20),
        child: Obx(
          () => ResponesiveButton(
            title: controller.isLoading.isFalse
                ? 'SEND RESET PASSWORD'
                : 'LOADING...',
            onPressed: () {
              if (controller.isLoading.isFalse) {
                controller.sendEmail();
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            header(),
            emailInput(),
            buttonSubmit(),
          ],
        ),
      ),
    ));
  }
}
