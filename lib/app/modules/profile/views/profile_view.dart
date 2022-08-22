import 'package:absensi_app/app/controllers/page_index_controller.dart';
import 'package:absensi_app/app/shared/colors.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:absensi_app/app/widgets/buttom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_large_text.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);

  final pageController = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    Widget profileContent(user, defaultProfile) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(25),
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
            ClipOval(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.network(
                  user['profile'] != null
                      ? user['profile'] != ''
                          ? user['profile']
                          : defaultProfile
                      : defaultProfile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 15),
            AppLargeText(
              text: user['name'].toString().toUpperCase(),
              size: 18,
            ),
            const SizedBox(height: 5),
            AppText(
              text: user['email'],
              size: 12,
            )
          ],
        ),
      );
    }

    Widget updateProfile(user) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.UPDATE_PROFILE, arguments: user);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.person),
              SizedBox(width: 15),
              AppText(
                text: "UPDATE PROFILE",
                color: AppColors.textBlack,
                fontWeight: FontWeight.bold,
                size: 14,
              ),
              Spacer(),
              Align(child: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
        ),
      );
    }

    Widget updatePassword() {
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.UPDATE_PASSWORD);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.lock),
              SizedBox(width: 15),
              AppText(
                text: "UPDATE PASSWORD",
                color: AppColors.textBlack,
                fontWeight: FontWeight.bold,
                size: 14,
              ),
              Spacer(),
              Align(child: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
        ),
      );
    }

    Widget addUsers(user) {
      if (user['role'] == "admin") {
        return GestureDetector(
          onTap: () => Get.toNamed(Routes.ADD_USERS),
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.person_add),
                SizedBox(width: 15),
                AppText(
                  text: "ADD USERS",
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.bold,
                  size: 14,
                ),
                Spacer(),
                Align(child: Icon(Icons.arrow_forward_ios_rounded))
              ],
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    }

    Widget logout() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: ResponesiveButton(
          title: "Logout",
          onPressed: () => controller.logout(),
        ),
      );
    }

    return Scaffold(
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                String defaultProfile =
                    'https://ui-avatars.com/api/?name=${user['name']}';
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    profileContent(user, defaultProfile),
                    updateProfile(user),
                    updatePassword(),
                    addUsers(user),
                    logout(),
                  ],
                );
              } else {
                return const Center(
                  child: Text('tadak dapat memuat data'),
                );
              }
            },
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          backgroundColor: AppColors.mainColor,
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex:
              pageController.pageIndex.value, //optional, default as 0
          onTap: (int i) => pageController.changePage(i),
        ));
  }
}
