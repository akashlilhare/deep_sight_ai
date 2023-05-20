import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:deep_sight_ai_labs/pages/splash_screen.dart';
import 'package:deep_sight_ai_labs/provider/auth_provider.dart';
import 'package:deep_sight_ai_labs/provider/dashboard_detail_provider.dart';
import 'package:deep_sight_ai_labs/provider/dashboard_provider.dart';
import 'package:deep_sight_ai_labs/provider/report_provider.dart';
import 'package:deep_sight_ai_labs/provider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(Phoenix(child: const MyApp()));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      fcmToken = value??"";

      print(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('Got a message whilst in the opened app!');
    //   print('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     print('Message also contained a notification: ${message.notification}');
    //   }
    // });
    //
    // FirebaseMessaging.onBackgroundMessage((message) async{
    //
    //   print(message.data);
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => DashboardProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => ReportProvider()),
          ChangeNotifierProvider(
              create: (context) => DashboardDetailProvider()),
        ],
        builder: (context, _) {
          return FutureBuilder<AdaptiveThemeMode>(
              future:
                  Provider.of<ThemeProvider>(context, listen: false).getTheme(),
              initialData: AdaptiveThemeMode.system,
              builder: (context, snapShot) {
                return AdaptiveTheme(
                    light: lightTheme,
                    dark: darkTheme,
                    initial: snapShot.hasData
                        ? snapShot.data ?? AdaptiveThemeMode.system
                        : AdaptiveThemeMode.system,
                    builder: (lightThemeData, darkThemeData) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Flutter Demo',
                        darkTheme: darkThemeData,
                        theme: lightThemeData,
                        home: SplashScreen(),
                      );
                    });
              });
        });
  }
}
