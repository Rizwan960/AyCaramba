import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ay_caramba/Model/reminders_model.dart';
import 'package:ay_caramba/Service/notification_services.dart';
import 'package:ay_caramba/Utils/Common/common_data.dart';
import 'package:ay_caramba/Utils/Provider/loading_management.dart';
import 'package:ay_caramba/Views/Splash/splash_screen.dart';
import 'package:ay_caramba/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_utils/util/utils.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    log(message.notification.toString());

    NotificationService.showNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        actionButtons: actionButtons);
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final actionButtons = [
  NotificationActionButton(
    key: 'Verify',
    label: 'Confirm Now',
    enabled: true,
  ),
];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final id = await cGetDeviceId();
  CommonData.deviceId = id;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initializeNotification();
  FirebaseMessaging messagingg = FirebaseMessaging.instance;
  FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value?.notification != null) {
      log(value!.notification.toString());

      NotificationService.showNotification(
          title: value.notification!.title!,
          body: value.notification!.body!,
          actionButtons: actionButtons);
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await messagingg.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    sound: true,
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      log(message.notification.toString());

      NotificationService.showNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          actionButtons: actionButtons);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      log(message.notification.toString());

      NotificationService.showNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          actionButtons: actionButtons);
    }
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoadingManagemet>(
            create: (context) => LoadingManagemet(),
          ),
          ChangeNotifierProvider<ParkingRemindersSingleton>(
            create: (context) => ParkingRemindersSingleton(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ay Caramba',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ));
  }
}
