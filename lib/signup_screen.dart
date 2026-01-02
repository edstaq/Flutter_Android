// ignore_for_file: use_build_context_synchronously

import 'package:edstaq_31_07_2025/form_screen.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
import 'package:edstaq_31_07_2025/signin_scree.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final Map formData = {};
  final _formkey = GlobalKey<FormState>();

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
                  'Sign Up',
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
              const SizedBox(
                width: 325,
                height: 49,
                child: Text(
                  'Sign up to explore EDSTAQ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC6C6C7),
                    fontSize: 15,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
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
                          //................validating.................
                          validator: (value) {
                            formData["email"] = value.toString().toLowerCase();
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
                          textInputAction: TextInputAction.next,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            counterText: "",
                            labelText: 'New Password',
                            hintText: 'Enter atleast 8 charector',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          //................validating.................
                          validator: (value) {
                            formData["password"] = value.toString();
                            if (value == "") {
                              return "Field is empty";
                            } else if (value!.length < 8) {
                              return "Enter atleast 8 charector";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            counterText: "",
                            labelText: 'Retype New Password',
                            hintText: 'Enter atleast 8 charector',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          //................validating.................
                          validator: (value) {
                            formData["repassword"] = value.toString();
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
                onTap: () async {
                  HapticFeedback.lightImpact();

                  if (_formkey.currentState!.validate()) {
                    //..........check validate.........
                    if (formData["password"] != formData["repassword"]) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black,
                          content: Text(
                            "Password does not match",
                            style: TextStyle(color: Colors.white),
                          )));
                    } else {
                      showProcessPopup(context);
                      //............sign up email and password....................
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: formData["email"],
                              password: formData["password"])
                          .then((value) async {
                        DatabaseReference snapshot = FirebaseDatabase.instance
                            .ref("users")
                            .child(FirebaseAuth.instance.currentUser!.uid
                                .toString());

                        // .................init time............................

                        PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();

                        final initInstallTime =
                            await snapshot.child("init_install_time").get();

                        if (initInstallTime.value == null) {
                          await snapshot.update({
                            "email": FirebaseAuth.instance.currentUser!.email,
                            "init_install_time": DateTime.now().toString(),
                            "init_install_version":
                                packageInfo.buildNumber.toString()
                          });
                        }

                        await snapshot.update({
                          "last_install_time": DateTime.now().toString(),
                          "last_install_version":
                              packageInfo.buildNumber.toString()
                        });
                        // .......................route........................

                        Navigator.of(context).pop();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const FormScreen()));
                      }).onError((error, stackTrace) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.black,
                                content: Text(
                                  "Failed!",
                                  style: TextStyle(color: Colors.white),
                                )));
                      });
                    }
                  }
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
                      child: const Text("Sign Up",
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
                child: TextButton(
                    // ........switch to signin...................
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => SigninScreen()));
                    },
                    child: const Text("Sign in",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ))),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
