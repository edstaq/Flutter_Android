import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/google_auth.dart';
import 'package:edstaq_31_07_2025/nav_bar.dart';
import 'package:edstaq_31_07_2025/signin_scree.dart';
import 'package:edstaq_31_07_2025/signup_screen.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            false, //to avoid shrinking of screen while keyboard appear
        body: SafeArea(
            child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  // height: 218,
                  child: Image.asset("assets/login_illustrate.png")),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              const Text("STUDY MATERIAL",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF292E7A))),
              const Text("A Great Place to Collect Material",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SigninScreen())); // route to signin
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          GoogleAuthScreen())); // route to google auth
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SignupScreen())); //route to signup
                        },
                        child: const Text("Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ))),
                    TextButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => NavBar(
                                      titles: Utils.homeData["titles"],
                                      icons: Utils.homeData["icons"],
                                      children: Utils.homeData["children"],
                                      posterData:
                                          Utils.homeData["posterData"])),
                              (route) => false);
                        },
                        child: const Text("Skip for now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ))),
                  ],
                ),
              )
            ],
          ),
        )));
  }
}
