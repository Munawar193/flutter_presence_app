import 'package:absensi_app/app/controllers/page_index_controller.dart';
import 'package:absensi_app/app/routes/app_pages.dart';
import 'package:absensi_app/app/shared/colors.dart';
import 'package:absensi_app/app/widgets/app_large_text.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final pageController = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    Widget header(user) {
      String defaultProfile =
          'https://ui-avatars.com/api/?name=${user['name']}';
      return Container(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const AppLargeText(text: "Hi, Welcome Back"),
              const SizedBox(height: 5),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                      user['address'] != null
                          ? user['address'].toString()
                          : "Belum ada lokasi",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      )))
            ]),
            ClipOval(
              child: Container(
                  height: 55,
                  width: 55,
                  decoration: const BoxDecoration(
                      color: Colors.grey, shape: BoxShape.circle),
                  child: Image.network(
                    user['profile'] ?? defaultProfile,
                    fit: BoxFit.cover,
                  )),
            )
          ],
        ),
      );
    }

    Widget cardInformation(user) => Container(
          height: 180,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppLargeText(text: user['role'], color: AppColors.textWhite),
              const SizedBox(
                height: 20,
              ),
              AppLargeText(
                  text: user['nim'], size: 28, color: AppColors.textWhite),
              AppText(text: user['name'], size: 18, color: AppColors.textWhite),
            ],
          ),
        );

    Widget absenInformation() => Container(
          height: 80,
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.defaultColor,
              borderRadius: BorderRadius.circular(15)),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamTodayPresence(),
              builder: (context, snapToday) {
                if (snapToday.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Map<String, dynamic>? dataToday = snapToday.data?.data();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                            fontWeight: FontWeight.bold, text: 'Masuk'),
                        const SizedBox(height: 3),
                        AppText(
                            text: dataToday?['masuk'] == null
                                ? "-"
                                : DateFormat.jms().format(DateTime.parse(
                                    dataToday!['masuk']['date'])))
                      ],
                    ),
                    VerticalDivider(
                      color: AppColors.mainColor.withOpacity(0.2),
                      thickness: 1.2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                            fontWeight: FontWeight.bold, text: 'Keluar'),
                        const SizedBox(height: 3),
                        AppText(
                            text: dataToday?['keluar'] == null
                                ? "-"
                                : DateFormat.jms().format(DateTime.parse(
                                    dataToday!['keluar']['date'])))
                      ],
                    )
                  ],
                );
              }),
        );

    Widget seeMore() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              Divider(
                color: AppColors.mainColor.withOpacity(0.2),
                thickness: 1.2,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLargeText(
                    text: "Last 5 days",
                    size: 14,
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.ALL_PRESENSI);
                    },
                    child: const AppLargeText(
                      text: "See more",
                      size: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blueColor,
                    ),
                  )
                ],
              )
            ],
          ),
        );

    Widget informationList() =>
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.streamLastPresence(),
            builder: (context, snapPresence) {
              if (snapPresence.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // ignore: prefer_is_empty
              if (snapPresence.data?.docs.length == 0 ||
                  snapPresence.data?.docs == null) {
                return Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.defaultColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                      child: AppText(
                    text: "Belum ada riwayat absen",
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  )),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapPresence.data?.docs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> data =
                      snapPresence.data!.docs[index].data();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Material(
                      color: AppColors.defaultColor,
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Get.toNamed(Routes.DETAIL_PRESENSI, arguments: data);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const AppText(
                                          text: "Masuk",
                                          fontWeight: FontWeight.w700),
                                      AppText(
                                        text: data['masuk']?['date'] == null
                                            ? "-"
                                            : DateFormat.jms().format(
                                                DateTime.parse(
                                                  data['masuk']!['date'],
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const AppText(
                                          text: "Keluar",
                                          fontWeight: FontWeight.w700),
                                      AppText(
                                        text: data['keluar']?['date'] == null
                                            ? "-"
                                            : DateFormat.jms().format(
                                                DateTime.parse(
                                                  data['keluar']!['date'],
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              AppText(
                                  text: DateFormat.yMMMEd()
                                      .format(DateTime.parse(data['date'])),
                                  fontWeight: FontWeight.w600)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            });

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
                return Column(
                  children: [
                    SizedBox(
                      height: 80,
                      child: header(user),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          cardInformation(user),
                          absenInformation(),
                          seeMore(),
                          informationList()
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
      ),
    );
  }
}
