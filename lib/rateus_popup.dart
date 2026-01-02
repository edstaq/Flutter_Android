import 'package:edstaq_31_07_2025/feedback_screen.dart';
// import 'package:enhanced_url_launcher/enhanced_url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void rateusPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dpop(),
  );
}

// ignore: must_be_immutable
class Dpop extends StatefulWidget {
  Dpop({super.key});
  List staring = [0, 0, 0, 0, 0]; // each star UI is on/off
  int starIndex = 0; // value of rated
  @override
  State<Dpop> createState() => _DpopState();
}

class _DpopState extends State<Dpop> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                          "Rate us!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "How would you love this app?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ............ managing and conditioning of 5 rating button...........
                              IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      for (var i = 0; i < 5; i++) {
                                        if (i <= 0) {
                                          widget.staring[i] = 1;
                                        } else {
                                          widget.staring[i] = 0;
                                        }
                                      }
                                      widget.starIndex = 1;
                                    });
                                  },
                                  icon: [
                                    const Icon(Icons.star_border_outlined),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    )
                                  ][widget.staring[0]]),
                              //
                              IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      for (var i = 0; i < 5; i++) {
                                        if (i <= 1) {
                                          widget.staring[i] = 1;
                                        } else {
                                          widget.staring[i] = 0;
                                        }
                                      }
                                      widget.starIndex = 2;
                                    });
                                  },
                                  icon: [
                                    const Icon(Icons.star_border_outlined),
                                    const Icon(Icons.star, color: Colors.amber)
                                  ][widget.staring[1]]),
                              //
                              IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      for (var i = 0; i < 5; i++) {
                                        if (i <= 2) {
                                          widget.staring[i] = 1;
                                        } else {
                                          widget.staring[i] = 0;
                                        }
                                      }
                                      widget.starIndex = 3;
                                    });
                                  },
                                  icon: [
                                    const Icon(Icons.star_border_outlined),
                                    const Icon(Icons.star, color: Colors.amber)
                                  ][widget.staring[2]]),
                              //
                              IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      for (var i = 0; i < 5; i++) {
                                        if (i <= 3) {
                                          widget.staring[i] = 1;
                                        } else {
                                          widget.staring[i] = 0;
                                        }
                                      }
                                      widget.starIndex = 4;
                                    });
                                  },
                                  icon: [
                                    const Icon(Icons.star_border_outlined),
                                    const Icon(Icons.star, color: Colors.amber)
                                  ][widget.staring[3]]),
                              //
                              IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      for (var i = 0; i < 5; i++) {
                                        if (i <= 4) {
                                          widget.staring[i] = 1;
                                        } else {
                                          widget.staring[i] = 0;
                                        }
                                      }
                                      widget.starIndex = 5;
                                    });
                                  },
                                  icon: [
                                    const Icon(Icons.star_border_outlined),
                                    const Icon(Icons.star, color: Colors.amber)
                                  ][widget.staring[4]]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // .................cancel rateing...................
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("No Thanks!")),
                            // ..................submitting rates................
                            TextButton(
                                onPressed: () async {
                                  //
                                  Navigator.of(context).pop();
                                  if (widget.starIndex != 0) {
                                    // ignore: use_build_context_synchronously
                                    submitPopup(context);
                                  }

                                  //.............launch to play store if rate>=3...........
                                  if (widget.starIndex >= 3) {
                                    await launchUrlString(
                                        "https://play.google.com/store/apps/details?id=com.asrgroup.cuguide&pcampaignid=web_share",
                                        mode: LaunchMode.externalApplication);
                                    await Future.delayed(const Duration(seconds: 1));
                                  } else if (widget.starIndex != 0) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FeedbackScreen()));
                                  }
                                },
                                child: const Text("Submit")),
                          ],
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
                alignment: Alignment.center,
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
                child: const Icon(
                  Icons.star,
                  size: 50,
                  color: Color(0xFFE5E5E5),
                ),
                //
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// .................thank you popup.............................
void submitPopup(BuildContext context) {
  showDialog(
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
                    // height: 261,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        const Text(
                          "Thank you for your feedback",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("ok")),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
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
                child: const Icon(
                  Icons.star,
                  size: 50,
                  color: Color(0xFFE5E5E5),
                ),
                //
              ),
            ],
          ),
        ],
      ),
    ),
  );
}