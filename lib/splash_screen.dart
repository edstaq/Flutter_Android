// ignore_for_file: use_build_context_synchronously

import 'package:edstaq_31_07_2025/auth_screen.dart';
import 'package:edstaq_31_07_2025/form_screen.dart';
import 'package:edstaq_31_07_2025/nav_bar.dart';
import 'package:edstaq_31_07_2025/update_screen.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // .....................waiting for 3 sec for next action.........................
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      // var box = await Hive.openBox('local_cubook');
      // List aiChatHist = box.get('history_all') ?? [];
      // Map aiUserParamVal = Map();

      Map data = {};
      List mainItem = [];
      List icons = [];
      List child = [];
      Map posterData = {};

      try {
        // try used for, in any situation come error

        // ...............making data for Homepage grid.................
        final ref = FirebaseDatabase.instance.ref('level');
        final snapshot = await ref.get();
        for (var element in snapshot.children) {
          Map child = element.value as Map;
          if (child["details"]["icon"] is Object &&
              child["details"]["title"] is Object) {
            data[element.key.toString()] = child;
          }
        }
        for (var element in data.keys.toList()) {
          mainItem.add(data[element]["details"]["title"]);
          icons.add(data[element]["details"]["icon"]);
          Map temp = data[element] as Map;
          temp.removeWhere((key, value) => key == "details");
          child.add(temp);
        }
        final posterRef = FirebaseDatabase.instance.ref('banner_poster');
        final posterSnapshot = await posterRef.get();

        if (posterSnapshot.value is! Map) {
          posterData = {};
        } else {
          posterData = posterSnapshot.value as Map;
        }
        Utils.homeData = {
          "titles": mainItem,
          "icons": icons,
          "children": child,
          "posterData": posterData
        };
        // ..............................................................

        // .................compalsary updation checking.................

        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        Map updateData =
            (await FirebaseDatabase.instance.ref("others/update").get()).value
                as Map;
        if (DateTime.now()
                    .difference(
                        DateTime.parse(updateData["version_release_date"]))
                    .inDays >
                updateData["duration"] &&
            int.parse(packageInfo.buildNumber) < updateData["latest_version"]) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const UpdateScreen()));
        }

        // ..................authentication checking...........................
        else if (FirebaseAuth.instance.currentUser == null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthScreen()));

          // ..................................................................
        } else {
          // .....................cheking for launch Form page..................
          final firebase = await FirebaseDatabase.instance
              .ref("users")
              .child(FirebaseAuth.instance.currentUser!.uid.toString())
              .get();

          final Map data = ((firebase.value ?? {}) as Map);
          // it used for get data to profile
          final List parameters = [
            "name",
            "institute_name",
            "institute_place",
            "institute_district",
            "mobile_number"
          ];
          // ////////////////////////////////////////
          // List aiUserParam = parameters;
          // for (var element in aiUserParam) {
          //   if (data.containsKey(element)) {
          //     aiUserParamVal[element] = data[element];
          //   }
          // }

          // aiChatHist.map((e) {
          //   Map dict = e;
          //   dict.removeWhere((key, value) => !["role", "parts"].contains(key));
          //   return dict.keys;
          // });

          // final ref_ai = await FirebaseDatabase.instance
          //     .ref("others/ai_backend/init")
          //     .get();
          // http.post(Uri.parse(ref_ai.value.toString()),
          //     body: jsonEncode(
          //         {"about_user": aiUserParamVal, "init_history": aiChatHist}),
          //     // ignore: avoid_print
          //     headers: {'Content-Type': 'application/json'}).then((value) => print(value.statusCode));
          // ////////////////////////////////////////
          if (!parameters.any((element) {
            return data[element] != null;
          })) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const FormScreen(
                      back: false,
                    )));
          } else {
            // ......Navigate to Home screen via Navbar >> Nestednav with grid data..........
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => NavBar(
                    titles: mainItem,
                    icons: icons,
                    children: child,
                    posterData: posterData)));
          }
        }
      } catch (e) {
        throw "Splash Screen: $e";
      }
    });

    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SizedBox(
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFF132391), Color(0xFF050F71)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.20),
                    ),
                  ),
                  child: SvgPicture.asset("assets/logo.svg"),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 115,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text.rich(
                //   TextSpan(
                //     children: [
                //       TextSpan(
                //         text: 'CU',
                //         style: TextStyle(
                //           color: Color(0xFF292E7A),
                //           fontSize: 22,
                //           fontFamily: 'Nunito',
                //           fontWeight: FontWeight.w900,
                //           height: 0,
                //         ),
                //       ),
                //       TextSpan(
                //         text: ' book',
                //         style: TextStyle(
                //           color: Color(0xFF292E7A),
                //           fontSize: 22,
                //           fontFamily: 'Nunito',
                //           height: 0,
                //         ),
                //       ),
                //     ],
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // SizedBox(
                //   width: 10,
                // ),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    )));
  }
}
