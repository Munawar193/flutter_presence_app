import 'package:absensi_app/app/widgets/buttom.dart';
import 'package:absensi_app/app/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../shared/colors.dart';
import '../../../widgets/app_large_text.dart';
import '../controllers/add_users_controller.dart';

class AddUsersView extends GetView<AddUsersController> {
  const AddUsersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget nimInput() => CustomFormInput(
          controller: controller.nimController,
          hintText: "Nim",
          icon: Icons.assignment_ind,
          keyboardType: TextInputType.number,
        );
    Widget nameInput() => CustomFormInput(
          controller: controller.nameController,
          hintText: "Name",
          icon: Icons.person,
          keyboardType: TextInputType.name,
        );
    Widget emailInput() => CustomFormInput(
          controller: controller.emailController,
          hintText: "Email",
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        );

    Widget submitButton() => Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Obx(
            () => ResponesiveButton(
              title: controller.isLoading.isFalse ? 'Add Users' : "Loading...",
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.addUsers();
                }
              },
            ),
          ),
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
          text: 'ADD USERS',
          size: 16,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          nimInput(),
          nameInput(),
          emailInput(),
          submitButton(),
        ],
      ),
    );
  }
}
