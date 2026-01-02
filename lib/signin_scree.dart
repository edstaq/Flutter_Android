// ignore_for_file: use_build_context_synchronously

import 'package:edstaq_31_07_2025/change_password.dart';
import 'package:edstaq_31_07_2025/form_screen.dart';
import 'package:edstaq_31_07_2025/nav_bar.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
import 'package:edstaq_31_07_2025/signup_screen.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});
  final _formkey = GlobalKey<FormState>();
  final formData = {};

  void submit(BuildContext context) {
    HapticFeedback.lightImpact();

    if (_formkey.currentState!.validate()) {
      //after validation completed
      showProcessPopup(context);
      // ................signing to email.........................
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: formData["email"], password: formData["password"])
          .then((value) async {
        DatabaseReference snapshot = FirebaseDatabase.instance
            .ref("users")
            .child(FirebaseAuth.instance.currentUser!.uid.toString());

        // .................update time..........................

        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        final initInstallTime = await snapshot.child("init_install_time").get();

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

        // .........check saved data for profile...............................

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
        // .............. checking routo to formscreen or navbar....................
        if (!saveDataState) {
          Navigator.of(context).pop();

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
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black,
          content: Text(
            "Failed! Check Email and Password",
            style: TextStyle(color: Colors.white),
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            // screen main column
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 30,
                          color: Color(0xFF292E7A),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Text(
                  'Sign In',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Image.asset("assets/mobile_verification.png")),
              const SizedBox(height: 8),
              const SizedBox(
                width: 325,
                height: 49,
                child: Text(
                  'Sign in to explore EDSTAQ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC6C6C7),
                    fontSize: 15,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            counterText: "",
                            labelText: 'Email',
                            hintText: 'example@gmail.com',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          //  validating email
                          validator: (value) {
                            formData["email"] =
                                value.toString().toLowerCase().trim();
                            if (value == "") {
                              return "Field is empty";
                            } else if (!EmailValidator.validate(value!)) {
                              return "Enter valid email";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onFieldSubmitted: (value) => submit(context),
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            counterText: "",
                            labelText: 'Password',
                            hintText: 'Enter atleast 8 charector',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          //  validating password
                          validator: (value) {
                            formData["password"] = value.toString().trim();
                            if (value == "") {
                              return "Field is empty";
                            } else if (value!.length < 8) {
                              return "Enter atleast 8 charector";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  submit(context);
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Container(
                      alignment: Alignment.center,
                      height: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF050F71),
                              Color.fromRGBO(40, 40, 109, 1)
                            ],
                          )),
                      child: const Text("Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                    )),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResetPw()));
                        },
                        child: const Text("Reset Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: const Text("Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
