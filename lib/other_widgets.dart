import 'package:edstaq_31_07_2025/cu_icons.dart';
// import 'package:enhanced_url_launcher/enhanced_url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// ..................popup for request of categories............................
void showCategorySubmitPopup(BuildContext context, List dlist) {
  var textController = TextEditingController();

  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          shadowColor: const Color.fromARGB(0, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 35),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        // height: 261,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 65),
                            const Text(
                              "Great! 👍",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Your every word is precious.\nRequest Your Category bellow",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 34,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Color(0xFFE5E5E5),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: TextField(
                                  minLines: 1,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: textController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintText: "Type here",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                DatabaseReference categoryRef = FirebaseDatabase
                                    .instance
                                    .ref("categorical_request");

                                if (textController.text.isNotEmpty) {
                                  String value = ">> ${[
                                    ...dlist,
                                    ...[textController.text]
                                  ].join(" >> ")}";
                                  String date = DateTime.now().toString();
                                  String key =
                                      date.replaceAll(RegExp('[.:]'), "-");

                                  await categoryRef.update({key: value});

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                backgroundColor: const Color(0xFF292E7A),
                              ),
                              child: const Padding(
                                padding:
                                    EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Text(
                                  "Submit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    decoration: const BoxDecoration(
                        color: Color(0xFF292E7A),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 25,
                            offset: Offset(0, 0),
                            spreadRadius: -6,
                          )
                        ]),
                    width: 84,
                    height: 84,
                    child: const SizedBox(
                        width: 70,
                        height: 70,
                        child: Icon(
                          CuIcons.request,
                          size: 50,
                          color: Color(0xFFE5E5E5),
                        )),
                    //
                  ),
                ],
              ),
            ],
          ),
        );
      });
}


// ..................popup for start google form................................
void showGformPopup(BuildContext context) => showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        shadowColor: const Color.fromARGB(0, 0, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 35),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      // height: 210,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 65),
                          const Text(
                            "Great! 👍",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Start uploading data by \nclick below",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              // ...........get URL form database..............
                              final urllinkRef = FirebaseDatabase.instance
                                  .ref('others/formlink');
                              final snapshot = await urllinkRef.get();

                              final Uri url =
                                  Uri.parse(snapshot.value.toString());
                              
                              // ..........launching URL.....................
                              await launchUrl(url,
                                  mode: LaunchMode.externalApplication);

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              backgroundColor: const Color(0xFF292E7A),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Text(
                                "Start",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(
                      color: Color(0xFF292E7A),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 25,
                          offset: Offset(0, 0),
                          spreadRadius: -6,
                        )
                      ]),
                  width: 84,
                  height: 84,
                  child: const SizedBox(
                      width: 70,
                      height: 70,
                      child: Icon(
                        CuIcons.request,
                        size: 50,
                        color: Color(0xFFE5E5E5),
                      )),
                  //
                ),
              ],
            ),
          ],
        ),
      ),
    );


// ....................pop for processing.................................
void showProcessPopup(BuildContext context) => showDialog(
    context: context,
    builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 280,
                height: 134,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      SizedBox(height: 35),
                      Text(
                        'Processsing',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w400,
                          height: 0.04,
                          letterSpacing: 0.45,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));