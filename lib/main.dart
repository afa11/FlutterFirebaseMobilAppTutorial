import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mobil_app_tutorial/data_uploader_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(
  // burası düzeltilmeli
  //options: DefaultFirebaseOptions.currentPlatform,
  //);
  runApp(GetMaterialApp(home: DataUploaderScreen()));
}
