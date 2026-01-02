import 'package:edstaq_31_07_2025/form_screen.dart';
import 'package:edstaq_31_07_2025/nav_bar.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

// ignore: must_be_immutable
class GoogleAuthScreen extends StatefulWidget {
  GoogleAuthScreen({super.key});
  bool isCompleted = false;

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}


class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            otherAction(context);
          });

          return const CircularProgressIndicator();
        }),
      ),
    );
  }

  // ................ this funtion is inside the widgets....................
  void otherAction(BuildContext context) async {
    googleSign(context).then((value) {
      FirebaseAuth.instance.signInWithCredential(value).then((value) async {

        // ................updating time and verison ..............................

        DatabaseReference snapshot = FirebaseDatabase.instance
            .ref("users")
            .child(FirebaseAuth.instance.currentUser!.uid.toString());

        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        final initInstallTime =
            await snapshot.child("init_install_time").get();

        if (initInstallTime.value == null) {
          await snapshot.update({
            "email": FirebaseAuth.instance.currentUser!.email,
            "init_install_time": DateTime.now().toString(),
            "init_install_version": packageInfo.buildNumber.toString()
          });
        }
        await snapshot.update({
          "last_install_time": DateTime.now().toString(),
          "last_install_version": packageInfo.buildNumber.toString()
        });

        // .......................check saved data.........................

        final firebase = await snapshot.get();
        bool saveDataState = true;

        if (firebase.value == null) {
          saveDataState = false;
        } else {
          final Map data = firebase.value as Map;
          for (var element in [
            "name",
            "institute_name",
            "institute_place",
            "institute_district",
            "mobile_number"
          ]) {
            if (data[element] == null) {
              saveDataState = false;
            }
          }
        }

        // .................choosing route form or navbar...........
        await Future.delayed(Duration.zero).whenComplete(() async {
          if (!saveDataState) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const FormScreen()));
          } else {
            if (Utils.mainNavigator.currentState != null &&
                Utils.mainNavigator.currentState!.canPop()) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => NavBar(
                          titles: Utils.homeData["titles"],
                          icons: Utils.homeData["icons"],
                          children: Utils.homeData["children"],
                          posterData: Utils.homeData["posterData"])),
                  (route) => false);
            }
          }
        });
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        scaffoldSnakeBar(context, "Failed!");
      });
    }).onError((error, stackTrace) {
      Navigator.of(context).pop();
      scaffoldSnakeBar(context, "Failed!");
    });
  }
}

// ..............sign in and return credintial...........................
Future<AuthCredential> googleSign(BuildContext context) async {
  GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
  GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;
  return GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
}

// .................snakebar messenge funtion.................
void scaffoldSnakeBar(BuildContext context, String massage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: Text(
        massage,
        style: const TextStyle(color: Colors.white),
      )));
}