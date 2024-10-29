import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:portfolio_app/components/login_error_popup.dart';
import 'package:portfolio_app/pages/splash_screen.dart';
import 'package:portfolio_app/services/auth/auth_gate.dart';
import 'package:portfolio_app/firebase_options.dart';
import 'package:portfolio_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase App Check
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  // Initialize Flutter Downloder
  await FlutterDownloader.initialize(
    debug: true,
  );

  bool isDataLoaded = await initialDataLoad();

  if (isDataLoaded) {
    FlutterNativeSplash.remove();
  }

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ));
}

Future<bool> initialDataLoad() async {
  // Authentication state check
  await FirebaseAuth.instance.authStateChanges().first;

  // Additional data load (e.g., user settings, profile data)
  await FirebaseFirestore.instance.collection('users').get();

  // Return true when everything is loaded
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: const AuthGate());
  }
}
