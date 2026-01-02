import 'package:edstaq_31_07_2025/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:edstaq_31_07_2025/firebase_options.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ...................Application theme setting...........................
const MaterialColor cuprimary = MaterialColor(0xFF292E7A, <int, Color>{
  50: Color(0xFFFFFEFC),
  100: Color(0xFFFFFCF7),
  200: Color(0xFFFFFBF2),
  300: Color(0xFFFFF9ED),
  400: Color(0xFFFFF7E9),
  500: Color(0xFF292E7A),
  600: Color(0xFFFFF5E2),
  700: Color(0xFFFFF3DE),
  800: Color(0xFFFFF2DA),
  900: Color(0xFFFFEFD3),
});

// .......................Main Of Application.................
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // for ensuring all are OK
  MobileAds.instance.initialize(); //initialize mobile ads
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // setup default orientation
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // initialize RDBMS
  await Hive.initFlutter(); // Initialize hive

  runApp(const MyApp()); //start application
}

// ...................Material app............................

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Utils.appNavigator,
      theme: ThemeData(
          primarySwatch: cuprimary,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Nunito"),
      home: const SplashScreen(),
    );
  }
}

// ........................................................
