import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:officialagreement/core/theme/app_theme.dart';
import 'package:officialagreement/screens/splash/splash_screen.dart';
import 'package:officialagreement/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MobileAds.instance.initialize();

  runApp(const OfficialAgreementApp());
}

class OfficialAgreementApp extends StatelessWidget {
  const OfficialAgreementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Official Agreement',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}