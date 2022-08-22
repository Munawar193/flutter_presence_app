// ignore_for_file: constant_identifier_names
import 'package:get/get.dart';
import 'package:absensi_app/app/modules/add_users/bindings/add_users_binding.dart';
import 'package:absensi_app/app/modules/add_users/views/add_users_view.dart';
import 'package:absensi_app/app/modules/all_presensi/bindings/all_presensi_binding.dart';
import 'package:absensi_app/app/modules/all_presensi/views/all_presensi_view.dart';
import 'package:absensi_app/app/modules/detail_presensi/bindings/detail_presensi_binding.dart';
import 'package:absensi_app/app/modules/detail_presensi/views/detail_presensi_view.dart';
import 'package:absensi_app/app/modules/forgot_password/bindings/forgot_password_binding.dart';
import 'package:absensi_app/app/modules/forgot_password/views/forgot_password_view.dart';
import 'package:absensi_app/app/modules/home/bindings/home_binding.dart';
import 'package:absensi_app/app/modules/home/views/home_view.dart';
import 'package:absensi_app/app/modules/login/bindings/login_binding.dart';
import 'package:absensi_app/app/modules/new_password/bindings/new_password_binding.dart';
import 'package:absensi_app/app/modules/new_password/views/new_password_view.dart';
import 'package:absensi_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:absensi_app/app/modules/profile/views/profile_view.dart';
import 'package:absensi_app/app/modules/update_password/bindings/update_password_binding.dart';
import 'package:absensi_app/app/modules/update_password/views/update_password_view.dart';
import 'package:absensi_app/app/modules/update_profile/bindings/update_profile_binding.dart';
import 'package:absensi_app/app/modules/update_profile/views/update_profile_view.dart';

import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.ADD_USERS,
      page: () => const AddUsersView(),
      binding: AddUsersBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => const NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PASSWORD,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENSI,
      page: () => DetailPresensiView(),
      binding: DetailPresensiBinding(),
    ),
    GetPage(
      name: _Paths.ALL_PRESENSI,
      page: () => const AllPresensiView(),
      binding: AllPresensiBinding(),
    ),
  ];
}
