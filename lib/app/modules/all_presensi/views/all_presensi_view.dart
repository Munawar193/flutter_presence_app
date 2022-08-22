import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../../../shared/colors.dart';
import '../../../widgets/app_text.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AllPresensiController>(
        builder: (c) {
          return SafeArea(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: controller.getallPresence(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.isEmpty ||
                    snapshot.data?.docs == null) {
                  return const Center(
                      child: AppText(
                    text: "Belum ada riwayat absen",
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data =
                        snapshot.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Material(
                        color: AppColors.defaultColor,
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_PRESENSI,
                                arguments: data);
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
                                        ),
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
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            Dialog(
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SfDateRangePicker(
                  monthViewSettings: const DateRangePickerMonthViewSettings(
                    firstDayOfWeek: 1,
                  ),
                  selectionMode: DateRangePickerSelectionMode.range,
                  showActionButtons: true,
                  onCancel: () => Get.back(),
                  onSubmit: (object) {
                    if (object != null) {
                      if ((object as PickerDateRange).endDate != null) {
                        controller.pickDate(
                          object.startDate!,
                          object.endDate!,
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
