import 'package:absensi_app/app/widgets/buttom.dart';
import 'package:absensi_app/app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/colors.dart';
import '../../../widgets/app_large_text.dart';
import '../../../widgets/app_text.dart';
import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppLargeText(
              text: 'Reset Your Password',
              size: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.mainColor,
            ),
            SizedBox(
              height: 10,
            ),
            AppText(
              text:
                  'Perhatikan untuk memasukan semua form input untuk melakukan update password',
              size: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textBlack,
            ),
          ],
        ),
      );
    }

    Widget currrentPassword() => CustomFormInput(
          controller: controller.currentController,
          hintText: 'Current Password',
          icon: Icons.lock,
          keyboardType: TextInputType.visiblePassword,
        );
    Widget newPassword() => CustomFormInput(
          controller: controller.newController,
          hintText: 'New Password',
          icon: Icons.lock,
          keyboardType: TextInputType.visiblePassword,
        );
    Widget confirmPassword() => CustomFormInput(
          controller: controller.confirmController,
          hintText: 'Confirm Password',
          icon: Icons.lock,
          keyboardType: TextInputType.visiblePassword,
        );

    Widget submitButton() => Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Obx(() => ResponesiveButton(
                title: controller.isloading.isFalse ? "Update" : "LOADING...",
                onPressed: () {
                  if (controller.isloading.isFalse) {
                    controller.updatePassword();
                  }
                },
              )),
        );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.mainColor,
          ),
        ),
        centerTitle: true,
        title: const AppLargeText(
          text: 'UPDATE PASSWORD',
          size: 16,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          header(),
          currrentPassword(),
          newPassword(),
          confirmPassword(),
          submitButton(),
        ],
      ),
    );
  }
}
