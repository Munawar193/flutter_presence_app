import 'package:absensi_app/app/shared/colors.dart';
import 'package:absensi_app/app/widgets/app_large_text.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:absensi_app/app/widgets/buttom.dart';
import 'package:absensi_app/app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/custome_password_form_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppLargeText(
              text: 'Welcome Back',
              size: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.mainColor,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: AppText(
                text: 'Hai Selamat datang di aplikasi absensi online.',
                size: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      );
    }

    Widget emailInput() {
      return CustomFormInput(
        controller: controller.emailController,
        hintText: "masuk email",
        icon: Icons.email,
        keyboardType: TextInputType.emailAddress,
      );
    }

    Widget passwordInput() {
      return CustomePasswordFormField(
        controller: controller.passwordController,
        hintText: "masuk password",
        icon: Icons.lock,
        keyboardType: TextInputType.visiblePassword,
      );
    }

    Widget forgotPassword() {
      return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: AppLargeText(
              text: 'Forgot password',
              size: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            Get.toNamed(Routes.FORGOT_PASSWORD);
          },
        ),
      );
    }

    Widget buttonSubmit() {
      return Container(
        margin: const EdgeInsets.only(bottom: 20, top: 20),
        child: Obx(
          () => ResponesiveButton(
            title: controller.isLoading.isFalse ? 'Login' : 'Loading...',
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                await controller.login();
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                emailInput(),
                passwordInput(),
                forgotPassword(),
              ],
            ),
            Column(
              children: [
                buttonSubmit(),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
