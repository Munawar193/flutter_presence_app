import 'package:absensi_app/app/widgets/app_large_text.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/colors.dart';

Future<void> defaultDialog({
  required Function() onPressed,
  required String title,
  required String text,
  required RxBool isLoading,
}) async {
  Get.defaultDialog(
    titlePadding: const EdgeInsets.only(top: 20),
    contentPadding:
        const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
    title: title,
    titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
    content: Column(
      children: [
        AppText(
          text: text,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
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
            onPressed: onPressed,
            child: AppLargeText(
              text: isLoading.isFalse ? "YES" : "LOADING...",
              size: 12,
              color: AppColors.textWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}
