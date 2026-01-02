import 'package:change_case/change_case.dart';
import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:edstaq_31_07_2025/youtube_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class EarnmonyScreen extends StatefulWidget {
  EarnmonyScreen({super.key});
  Map data = {}; //created a empty map for receive data
  int times = 0;

  @override
  State<EarnmonyScreen> createState() => _EarnmonyScreenState();
}

class _EarnmonyScreenState extends State<EarnmonyScreen> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.data = Utils.earnInfoBackup;
    });
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
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
            // animation for scroll
            AnimatedBuilder(
                animation: Utils.scrollcontrollerEarn,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: (Utils.scrollcontrollerEarn.hasClients)
                        ? (Utils.scrollcontrollerEarn.position.pixels >= 10)
                            ? 0
                            : 13
                        : 13,
                  );
                }),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: AnimatedBuilder(
                    animation: Utils.scrollcontrollerEarn,
                    builder: (context, snapshot) {
                      return AnimatedDefaultTextStyle(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Utils.scrollcontrollerEarn.hasClients
                                ? Utils.scrollcontrollerEarn.position.pixels >=
                                        10
                                    ? 22
                                    : 34
                                : 34,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700,
                          ),
                          duration: const Duration(milliseconds: 300),
                          child: const Text(
                            'Earn Plan',
                            maxLines: 1,
                          ));
                    })),
            const SizedBox(height: 13),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  controller: Utils.scrollcontrollerEarn,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    // screen main column
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView(
                          controller: ScrollController(keepScrollOffset: true),
                          shrinkWrap: true,
                          children: [
                            ...[
                              const SizedBox(
                                height: 10,
                              )
                            ],
                            // loading data from database and listing it in UI
                            ...[
                              Builder(builder: (context) {
                                if (widget.data.isEmpty && widget.times == 0) {
                                  // this condition for load once
                                  Future.delayed(Duration.zero)
                                      .then((value) async {
                                    showProcessPopup(context); // process pop up
                                    final posterRef = FirebaseDatabase.instance
                                        .ref('earn_info');
                                    final posterSnapshot =
                                        await posterRef.get();
                                    if (posterSnapshot.value is! Map) {
                                      setState(() {
                                        widget.data = {};
                                        Utils.earnInfoBackup = widget.data;
                                      });
                                    } else {
                                      setState(() {
                                        widget.data =
                                            posterSnapshot.value as Map;
                                        Utils.earnInfoBackup = widget.data;
                                      });
                                    }
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                  });
                                  widget.times = 1;
                                }
                                return ListView.separated(
                                    controller: ScrollController(
                                        keepScrollOffset: true),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return MessageWidget(
                                        title: widget.data.values
                                            .toList()[index]["title"],
                                        body: widget.data.values.toList()[index]
                                            ["body"],
                                        hintCenter: widget.data.values
                                            .toList()[index]["hintcenter"],
                                        hintLeft: widget.data.values
                                            .toList()[index]["hintleft"],
                                        link: widget.data.values.toList()[index]
                                            ["redirect"],
                                        hintRight: timeDiff(
                                            widget.data.values.toList()[index]
                                                ["time"],
                                            DateTime.now()),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        height: 15,
                                        color: Color(0x00000000),
                                      );
                                    },
                                    itemCount: widget.data.length);
                              }),
                            ],
                            ...[
                              const SizedBox(
                                height: 20,
                              )
                            ],
                            ...[
                              (widget.data.isEmpty)
                                  ? const Center(
                                      child: Text(
                                        "No Items Found!",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Color(0xFF292E7A),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 20,
                                    )
                            ]
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {super.key,
      required this.title,
      required this.body,
      required this.hintCenter,
      required this.hintLeft,
      required this.link,
      required this.hintRight});
  final String title;
  final String body;
  final String hintLeft;
  final String hintCenter;
  final String hintRight;
  final String link;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (link.isNotEmpty) {
          Launcher().launch(link);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      'No Redirection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.45,
                      ),
                    ),
                  ),
                );
              });
        }
      },
      child: FittedBox(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: 363,

          // height: 127,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 10,
                offset: Offset(2, 4),
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    CuIcons.money,
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Text(
                      title.toTitleCase(),
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  body.toSentenceCase(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hintLeft,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFFC6C6C7),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Text(
                    hintCenter,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color(0xFFC6C6C7),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Text(
                    hintRight,
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFFC6C6C7),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}