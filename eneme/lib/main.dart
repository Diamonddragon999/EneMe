
import 'splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'NotificationManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var notificationManager = NotificationManager();
  await notificationManager.initNotifications();
  // init the hive
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EneMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home:const SplashScreen(),
    );
  }
}