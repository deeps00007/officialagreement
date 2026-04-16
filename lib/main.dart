import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:officialagreement/core/theme/app_theme.dart';
import 'package:officialagreement/screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
