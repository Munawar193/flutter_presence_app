import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../routes/app_pages.dart';
import '../widgets/custome_dialog_widget.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) {
    switch (i) {
      case 1:
        verifyAttendance();
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  // fungsi untuk melakukan absensi
  Future<void> verifyAttendance() async {
    Map<String, dynamic> dataRespone = await determinePosition();
    if (!dataRespone['error']) {
      Position position = dataRespone['position'];
      // mengambil data maping dari postition sekarang
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // ubah data latitude dan lingitude menjadi format geocoding
      String address =
          "${placemarks[1].name} ${placemarks[0].subLocality}, ${placemarks[0].locality}";
      String shortAddress = "${placemarks[0].subLocality}";
      // update position
      await updatePosition(position, address);

      // cek distance between 2 position
      double distance = Geolocator.distanceBetween(5.522302012928133,
          95.41099802923114, position.latitude, position.longitude);

      // menambahkan absensi ke db
      await addPresenceUser(position, shortAddress, distance);
      // Get.snackbar("Success",
      //     "${placemarks[1].name} ${placemarks[0].subLocality}, ${placemarks[0].locality}");
    } else {
      Get.snackbar("Terjadi Kesalahan", dataRespone['message']);
    }
  }

  Future<void> addPresenceUser(
    Position position,
    String shortAddress,
    double distance,
  ) async {
    String uid = auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> collectionPresence =
        firestore.collection('users').doc(uid).collection('presence');
    QuerySnapshot<Map<String, dynamic>> snapsohPresence =
        await collectionPresence.get();
    DateTime dateNow = DateTime.now();
    String todayDocId = DateFormat.yMd().format(dateNow).replaceAll('/', '-');
    String status = "Di Luar Area";
    if (distance <= 200) {
      status = "Di Dalam Area";
    }
    if (snapsohPresence.docs.isEmpty) {
      await defaultDialog(
        title: 'VALIDASI PRESENCE',
        text: 'Apakah kamu ingin melakukan absensi ( MASUK ) sekarang ?',
        isLoading: isLoading,
        onPressed: () async {
          if (isLoading.isFalse) {
            await collectionPresence.doc(todayDocId).set({
              'date': dateNow.toIso8601String(),
              'masuk': {
                'date': dateNow.toIso8601String(),
                'lat': position.latitude,
                'long': position.longitude,
                'address': shortAddress,
                'status': status,
                'distance': distance,
              }
            });
          }
          isLoading.value = false;
          Get.back();
          Get.snackbar("Success", "Kamu telah melakukan absen");
        },
      );
    } else {
      DocumentSnapshot<Map<String, dynamic>> todayDocument =
          await collectionPresence.doc(todayDocId).get();

      if (todayDocument.exists == true) {
        Map<String, dynamic>? dataPresenceToday = todayDocument.data();
        if (dataPresenceToday?['keluar'] != null) {
          Get.snackbar(
              "Success", 'Kamu Sudah melakukan absen MASUK & KELUAR hariini');
        } else {
          // absen keluar
          await defaultDialog(
            title: 'VALIDASI PRESENCE',
            text: 'Apakah kamu ingin melakukan absensi ( KELUAR ) sekarang ?',
            isLoading: isLoading,
            onPressed: () async {
              if (isLoading.isFalse) {
                await collectionPresence.doc(todayDocId).update({
                  'keluar': {
                    'date': dateNow.toIso8601String(),
                    'lat': position.latitude,
                    'long': position.longitude,
                    'address': shortAddress,
                    'status': status,
                    'distance': distance,
                  }
                });
              }
              isLoading.value = false;
              Get.back();
              Get.snackbar(
                  "Success", 'Berhasil melakukan absen untuk jam KELUAR');
            },
          );
        }
      } else {
        await defaultDialog(
          title: 'VALIDASI PRESENCE',
          text: 'Apakah kamu ingin melakukan absensi ( MASUK ) sekarang ?',
          isLoading: isLoading,
          onPressed: () async {
            if (isLoading.isFalse) {
              await collectionPresence.doc(todayDocId).set({
                'date': dateNow.toIso8601String(),
                'masuk': {
                  'date': dateNow.toIso8601String(),
                  'lat': position.latitude,
                  'long': position.longitude,
                  'address': shortAddress,
                  'status': status,
                  'distance': distance,
                }
              });
            }
            isLoading.value = false;
            Get.back();
            Get.snackbar(
                "Success", 'Berhasil melakukan absen untuk jam KELUAR');
          },
        );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    await firestore.collection('users').doc(uid).update(
      {
        'position': {
          'lat': position.latitude,
          'long': position.longitude,
        },
        'address': address
      },
    );
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        'message': 'Tidak dapat mengakses lokasi.',
        'error': true,
      };
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          'message': 'Izin untuk mengakses lokasi ditolak',
          'error': true,
        };
        // Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        'message':
            'Kamu tidak memberika izin akses lokasi, ubah untuk memberikan izin akses lokasi',
        'error': true,
      };
      // Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    return {
      'position': position,
      'message': 'Berhasil medapatkan posisi device',
      'error': false,
    };
  }
}
