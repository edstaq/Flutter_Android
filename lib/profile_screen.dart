import 'package:change_case/change_case.dart';
import 'package:edstaq_31_07_2025/change_password.dart';
import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // .............getting user data from firebase............................
    if (FirebaseAuth.instance.currentUser != null) {
      if (Utils.formUserDetails.isEmpty) {
        final firestore = FirebaseDatabase.instance
            .ref("users")
            .child(FirebaseAuth.instance.currentUser!.uid);

        firestore.get().then((value) {
          setState(() {
            Utils.formUserDetails = value.value as Map;
          });
        });
      }
    }

    return Scaffold(
      body: SafeArea(
          child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                  controller: Utils.scrollcontrollerProfile,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                      // screen main column
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 56,
                          width: MediaQuery.of(context).size.width * 0.85,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    FocusScope.of(context).unfocus();
                                    Scaffold.of(context).openDrawer();
                                  },
                                  icon: SvgPicture.asset("assets/menu.svg")),
                            ],
                          ),
                        ),
                        const SizedBox(height: 13),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: const Text(
                            'Profile',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Icon(
                          CuIcons.profile2,
                          size: 100,
                          color: Color(0xFFE5E5E5),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 51,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFE5E5E5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Fullname',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // .........managing id data become null..............
                              Text(
                                (Utils.formUserDetails["name"] == null)
                                    ? "---"
                                    : Utils.formUserDetails["name"]
                                        .toString()
                                        .toTitleCase(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 51,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFE5E5E5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Institute Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // .........managing id data become null..............
                              Text(
                                (Utils.formUserDetails["institute_name"] ==
                                        null)
                                    ? "---"
                                    : Utils.formUserDetails["institute_name"]
                                        .toString()
                                        .toTitleCase(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 51,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFE5E5E5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Institute Place',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // .........managing id data become null..............
                              Text(
                                (Utils.formUserDetails["institute_place"] ==
                                        null)
                                    ? "---"
                                    : Utils.formUserDetails["institute_place"]
                                        .toString()
                                        .toTitleCase(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 51,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFE5E5E5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Institute District',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // .........managing id data become null..............
                              Text(
                                (Utils.formUserDetails["institute_district"] ==
                                        null)
                                    ? "---"
                                    : Utils
                                        .formUserDetails["institute_district"]
                                        .toString()
                                        .toTitleCase(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 51,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFE5E5E5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Mobile Number',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // .........managing id data become null..............
                              Text(
                                (Utils.formUserDetails["mobile_number"] == null)
                                    ? "---"
                                    : Utils.formUserDetails["mobile_number"]
                                        .toString()
                                        .toTitleCase(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 51,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFE5E5E5)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Email',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              // .........managing id data become null..............
                              Text(
                                (FirebaseAuth.instance.currentUser == null)
                                    ? "---"
                                    : FirebaseAuth.instance.currentUser!.email
                                        .toString(),
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // .................managing forgetting password button...............
                        (FirebaseAuth.instance.currentUser != null &&
                                FirebaseAuth.instance.currentUser!.photoURL ==
                                    null)
                            ? TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ResetPw()));
                                },
                                child: const Text("Reset Password",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )))
                            : const SizedBox(),
                        const SizedBox(height: 60)
                      ])))),
    );
  }
}