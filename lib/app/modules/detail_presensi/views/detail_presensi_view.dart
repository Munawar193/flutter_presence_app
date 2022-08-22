import 'package:absensi_app/app/shared/colors.dart';
import 'package:absensi_app/app/widgets/app_large_text.dart';
import 'package:absensi_app/app/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  DetailPresensiView({Key? key}) : super(key: key);

  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
          color: AppColors.mainColor,
        ),
        backgroundColor: Colors.transparent,
        // toolbarHeight: 60,
        centerTitle: true,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: AppLargeText(
            text: "DETAIL PRESENCE",
            fontWeight: FontWeight.w600,
            size: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.defaultColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AppLargeText(
                    text: "MASUK",
                    color: AppColors.mainColor.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: AppLargeText(
                    text: DateFormat.yMMMEd()
                        .format(DateTime.parse(data['date'])),
                    color: AppColors.mainColor.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                    size: 16,
                  ),
                ),
                Divider(
                  color: AppColors.mainColor.withOpacity(0.3),
                  thickness: 2,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomeInformationCard(
                        title: 'Jam',
                        text: DateFormat.jms()
                            .format(
                              DateTime.parse(
                                data['masuk']['date'],
                              ),
                            )
                            .replaceAll(":", " : "),
                      ),
                      CustomeInformationCard(
                        title: 'Alamat',
                        text: data['masuk']['address'],
                      ),
                      CustomeInformationCard(
                        title: 'Posisi',
                        text:
                            "${data['masuk']['lat']}, ${data['masuk']['long']}",
                      ),
                      CustomeInformationCard(
                        title: 'Status',
                        text: data['masuk']['status'],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.defaultColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AppLargeText(
                    text: "KELUAR",
                    color: AppColors.mainColor.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: AppLargeText(
                    text: DateFormat.yMMMEd()
                        .format(DateTime.parse(data['date'])),
                    color: AppColors.mainColor.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                    size: 16,
                  ),
                ),
                Divider(
                  color: AppColors.mainColor.withOpacity(0.3),
                  thickness: 2,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomeInformationCard(
                          title: 'Jam',
                          text: data['keluar']?['date'] == null
                              ? '-'
                              : DateFormat.jms()
                                  .format(
                                      DateTime.parse(data['keluar']['date']))
                                  .replaceAll(":", " : ")),
                      CustomeInformationCard(
                        title: 'Alamat',
                        text:
                            "${data['keluar']?['address'] == null ? '-' : data['keluar']['address']}",
                      ),
                      CustomeInformationCard(
                          title: 'Posisi',
                          text: data['keluar']?['lat'] == null &&
                                  data['keluar']?['long'] == null
                              ? '-'
                              : "${data['keluar']!['lat']}, ${data['keluar']!['long']}"),
                      CustomeInformationCard(
                          title: 'Status',
                          text: data['keluar']?['status'] == null
                              ? "-"
                              : "${data['keluar']!['status']}"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomeInformationCard extends StatelessWidget {
  final String title;
  final String text;
  const CustomeInformationCard({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: title,
                fontWeight: FontWeight.w600,
                size: 16,
              ),
              const AppText(
                text: ":",
                fontWeight: FontWeight.w600,
                size: 16,
              ),
            ],
          ),
        ),
        AppText(
          text: text,
          fontWeight: FontWeight.w600,
          size: 16,
        )
      ],
    );
  }
}
