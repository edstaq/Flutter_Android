import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/google_auth.dart';
import 'package:edstaq_31_07_2025/signin_scree.dart';
import 'package:edstaq_31_07_2025/signup_screen.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TempAuthScreen extends StatelessWidget {
  const TempAuthScreen({super.key, this.fromProfile = false});
  final bool fromProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  // height: 218,
                  child: Image.asset("assets/temp_login_image.png")),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              const Text("STUDY MATERIAL",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF292E7A))),
              const Text("Register for free to access the materials",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  // ...........route to sign in................
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SigninScreen()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFE5E5E5))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 20,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Sign in with Email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // ...........route to google auth................
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GoogleAuthScreen()));
                },
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF132391), Color(0xFF050F71)],
                        )),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CuIcons.google,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Sign in with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          // ...........route to sign up................
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                        },
                        child: const Text("Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ))),
                    (!fromProfile)
                        ? TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Go Back",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )))
                        : SingleChildScrollView(
                            controller: Utils.scrollcontrollerProfile,
                            child: const Column(
                              children: [SizedBox()],
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
