import 'dart:io';

import 'package:absensi_app/app/shared/colors.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:absensi_app/app/widgets/buttom.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/app_large_text.dart';
import '../../../widgets/custom_form_field.dart';
import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;

  UpdateProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.nimController.text = user['nim'];
    controller.nameController.text = user['name'];
    controller.emailController.text = user['email'];

    Widget updateProfile() {
      return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            GetBuilder<UpdateProfileController>(
              builder: (context) {
                if (controller.image != null) {
                  return SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        File(controller.image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  if (user['profile'] != null) {
                    return SizedBox(
                      height: 150,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          user['profile'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      controller.pickImage();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.starColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: AppText(
                        text: 'Choose',
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (user['profile'] != null) {
                        controller.deleteProfile(user["uid"]);
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: AppText(
                        text: 'Deleted',
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    }

    Widget emailInput() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomFormInput(
              controller: controller.emailController,
              hintText: 'email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 55,
            width: 70,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: AppText(
                text: "Can't Edit",
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                size: 11,
              ),
            ),
          )
        ],
      );
    }

    Widget nimInput() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomFormInput(
              controller: controller.nimController,
              hintText: 'nim',
              icon: Icons.assignment_ind,
              keyboardType: TextInputType.name,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 55,
            width: 70,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: AppText(
                text: 'Edit',
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                size: 11,
              ),
            ),
          )
        ],
      );
    }

    Widget nameInput() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: CustomFormInput(
              controller: controller.nameController,
              hintText: 'name',
              icon: Icons.person,
              keyboardType: TextInputType.name,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 55,
            width: 70,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: AppText(
                text: 'Edit',
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
                size: 11,
              ),
            ),
          )
        ],
      );
    }

    Widget submitButton() {
      return Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ResponesiveButton(
            title: controller.isLoading.isFalse ? 'Update' : "LOADING...",
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                await controller.updatProfile(user['uid']);
              }
            },
          ),
        ),
      );
    }

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
          text: 'UPDATE PROFILE',
          size: 16,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        physics: const BouncingScrollPhysics(),
        children: [
          updateProfile(),
          emailInput(),
          nimInput(),
          nameInput(),
          submitButton(),
        ],
      ),
    );
  }
}
