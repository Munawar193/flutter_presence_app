import 'package:absensi_app/app/shared/colors.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ResponesiveButton extends StatelessWidget {
  bool? isResponesive;
  double width;
  String title;
  Function() onPressed;

  ResponesiveButton({
    Key? key,
    this.width = double.maxFinite,
    this.isResponesive = false,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.mainColor,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: AppText(
            text: title,
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            size: 14,
          ),
        ));
  }
}
