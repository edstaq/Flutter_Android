import 'package:change_case/change_case.dart';
import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'utils.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});
  Map data = {};
  int flag = 0;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.data = Utils.notificationBackup;
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
                children: [
                  IconButton(
                      onPressed: () {
                        // ...............drawer opening....................
                        HapticFeedback.lightImpact();
                        Scaffold.of(context).openDrawer();
                        FocusScope.of(context).unfocus();
                      },
                      icon: SvgPicture.asset("assets/menu.svg")),
                 
                ],
              ),
            ),
            AnimatedBuilder(
                animation: Utils.scrollcontrollerNotify,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: (Utils.scrollcontrollerNotify.hasClients)
                        ? (Utils.scrollcontrollerNotify.position.pixels >= 10)
                            ? 0
                            : 13
                        : 13,
                  );
                }),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: AnimatedBuilder(
                    animation: Utils.scrollcontrollerNotify,
                    builder: (context, snapshot) {
                      return AnimatedDefaultTextStyle(
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Utils.scrollcontrollerNotify.hasClients
                                ? Utils.scrollcontrollerNotify.position
                                            .pixels >=
                                        10
                                    ? 22
                                    : 34
                                : 34,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w700,
                          ),
                          duration: const Duration(milliseconds: 300),
                          child: const Text(
                            "Notification",
                            maxLines: 1,
                          ));
                    })),
            const SizedBox(height: 3),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  controller: Utils.scrollcontrollerNotify,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    // screen main column
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
                            // ..........notification list builder..............
                            ...[
                              Builder(builder: (context) {
                                if (widget.data.isEmpty && widget.flag == 0) {
                                  Future.delayed(Duration.zero)
                                      .then((value) async {
                                    try {
                                      showProcessPopup(context);
                                      //
                                      final publicNotify =
                                          ((await FirebaseDatabase.instance
                                                      .ref('notification')
                                                      .get())
                                                  .value ??
                                              {}) as Map;
                                      Map privateNotify = {};
                                      if (FirebaseAuth.instance.currentUser !=
                                          null) {
                                        privateNotify = ((await FirebaseDatabase
                                                    .instance
                                                    .ref(
                                                        'user_files/notification')
                                                    .child(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .get())
                                                .value ??
                                            {}) as Map;
                                      }
                                      // .............combining public and private notification...................
                                      Map fullNotify = publicNotify;
                                      fullNotify.addAll(privateNotify);
                                      setState(() {
                                        widget.data = fullNotify;
                                        Utils.notificationBackup = widget.data;
                                      });
                                      setState(() {
                                        widget.flag = 1;
                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      setState(() {
                                        widget.data = {};
                                        Utils.notificationBackup = widget.data;
                                      });
                                      setState(() {
                                        widget.flag = 1;
                                      });
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    }
                                  });
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
                                        time: timeDiff(
                                            widget.data.values.toList()[index]
                                                ["time"],
                                            DateTime.now()),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(
                                        color: Color(0x00000000),
                                        height: 15,
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
                            // ...................empty information.............
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
                                  : const SizedBox()
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
  const MessageWidget({
    super.key,
    required this.title,
    required this.body,
    required this.time,
  });
  final String title;
  final String body;
  final String time;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.all(15),
        width: 363,
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
                  CuIcons.notificationFill,
                ),
                const SizedBox(
                  width: 18,
                ),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
                Text(
                  time,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFFC6C6C7),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 0,
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
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}