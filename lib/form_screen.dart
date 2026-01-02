import 'package:edstaq_31_07_2025/nav_bar.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<String, dynamic> formData = {};

final _formkey = GlobalKey<FormState>();

class FormScreen extends StatelessWidget {
  const FormScreen({super.key, this.back = true});
  final bool back;

  //  this funtion is validates and submitting to database and route
  void formSubmit(BuildContext context) async {
    HapticFeedback.lightImpact();
    if (_formkey.currentState!.validate()) {
      // check validate
      FocusScope.of(context).unfocus();
      showProcessPopup(context); // process
      FirebaseDatabase.instance
          .ref("users")
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .update(formData)
          .whenComplete(() {
        if (Utils.mainNavigator.currentState != null &&
            Utils.mainNavigator.currentState!.canPop()) {
          Navigator.of(context)
              .pop(); // pop done multiple times because remove untile makes errors
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          // navigatinf to NAVBAR
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => NavBar(
                      titles: Utils.homeData["titles"],
                      icons: Utils.homeData["icons"],
                      children: Utils.homeData["children"],
                      posterData: Utils.homeData["posterData"])),
              (route) => false);
        }
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.black,
            content: Text(
              "Failed!",
              style: TextStyle(color: Colors.white),
            )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                children: [
                  (back)
                      ? IconButton(
                          onPressed: () async {
                            HapticFeedback.lightImpact();

                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 30,
                            color: Color(0xFF292E7A),
                          ))
                      : const SizedBox(),
                ],
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text(
                'Enter Details',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue:
                            FirebaseAuth.instance.currentUser!.displayName,
                        textInputAction: TextInputAction.next,
                        maxLength: 30,
                        decoration: const InputDecoration(
                          counterText: "",
                          labelText: 'Name',
                          hintText: 'ex: John',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          // validating a field
                          formData["name"] = value.toString().trim();
                          if (value == null || value.trim().isEmpty) {
                            return "The Field is empty";
                          } else if (value.length < 3) {
                            return "The data is not valid";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          counterText: "",
                          labelText: 'Institute Name',
                          hintText: 'Enter current Institute Name',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          // validating a field
                          formData["institute_name"] = value.toString().trim();
                          if (value == null || value.trim().isEmpty) {
                            return "The Field is empty";
                          } else if (value.length < 3) {
                            return "The data is not valid";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        maxLength: 30,
                        decoration: const InputDecoration(
                          counterText: "",
                          labelText: 'Institute place',
                          hintText: 'Enter current Institute Place',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          // validating a field
                          formData["institute_place"] = value.toString().trim();
                          if (value == null || value.trim().isEmpty) {
                            return "The Field is empty";
                          } else if (value.length < 3) {
                            return "The data is not valid";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        maxLength: 30,
                        decoration: const InputDecoration(
                          counterText: "",
                          labelText: 'Institute district',
                          hintText: 'Enter current Institute district',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          // validating a field
                          formData["institute_district"] =
                              value.toString().trim();
                          if (value == null || value.trim().isEmpty) {
                            return "The Field is empty";
                          } else if (value.length < 3) {
                            return "The data is not valid";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onEditingComplete: () => formSubmit(context),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          counterText: "",
                          labelText: 'Mobile Number',
                          hintText: 'Enter 10 digit mobile number',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          // validating a field
                          formData["mobile_number"] =
                              "+91${value.toString().trim()}";

                          if (value == null || value.trim().isEmpty) {
                            return "The Field is empty";
                          } else if (value.length < 10) {
                            return "Enter 10 digit Mobile number";
                          } else if (!value.trim().split("").every((element) {
                            try {
                              int.parse(element);
                              return true;
                            } catch (e) {
                              return false;
                            }
                          })) {
                            return "Input valid mobile number";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          formSubmit(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF132391), Color(0xFF050F71)],
                              )),
                          child: const Text("Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
