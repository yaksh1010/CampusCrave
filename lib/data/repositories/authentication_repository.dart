import 'package:campuscrave/pages/new_onboard.dart';
import 'package:campuscrave/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
 static AuthenticationRepository get instance => Get.find();

/// Variables
  final deviceStorage = GetStorage();
/// Called from main.dart on app launch
  @override
  void onReady() {
  FlutterNativeSplash.remove(); 
  screenRedirect();
  }
/// Function to Show Relevant Screen
  screenRedirect() async {
    if(kDebugMode){
      print('===get storage auth===');
      print(deviceStorage.read('isFirstTime'));
    }



    deviceStorage.writeIfNull('isFirstTime',true);
    deviceStorage.read('isFirstTime') != true ? Get.offAll(() => const LoginScreen()) : Get.offAll(const NewOnboard());
  }





}