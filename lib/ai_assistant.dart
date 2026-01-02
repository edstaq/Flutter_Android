import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';

Widget AiIcon() => Container(
      height: 30,
      // width: 60,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF132391), Color(0xFF050F71)],
          ),
          borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: Row(
          children: [
            SvgPicture.asset("assets/bot.svg", color: Colors.white),
            const SizedBox(width: 2),
            const Text("AI Assistant", style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );

class GeminiAi extends GetxController {
  List _historyData = [];
  GeminiAi(this._historyData);

  void addChat(String role, String avathar, List parts, String time) {
    Map chat = {"role": role, "parts": parts, "avathar": avathar, "time": time};
    _historyData.add(chat);
    update();
  }

  List get historyAll => _historyData;
  set historyAll(List x) {
    _historyData = x;
    update();
  }
}

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.hist});
  List hist = [];
  TextEditingController ctrl = TextEditingController();
  ScrollController scrlCtrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    String? domain;
    GeminiAi geminiAi = Get.put(GeminiAi(hist));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 228, 228),
      appBar: AppBar(
        title: const Text("AI Assistant"),
        backgroundColor: const Color(0xFF050F71),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () async {
                var box = await Hive.openBox('local_cubook');
                box.put('history_all', []);
                geminiAi.historyAll = [];
              },
              child: const Text(
                "Clear chat",
                style: TextStyle(color: Colors.white70),
              ))
        ],
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: GetBuilder<GeminiAi>(builder: (context) {
            Future.delayed(Duration.zero).then((value) => scrlCtrl.animateTo(
                scrlCtrl.position.maxScrollExtent,
                duration: const Duration(microseconds: 300),
                curve: Curves.fastOutSlowIn));
            return ListView.separated(
                controller: scrlCtrl,
                itemBuilder: (context, index) {
                  if (index == 0 || index == geminiAi.historyAll.length + 1) {
                    return const SizedBox(height: 20);
                  } else {
                    Map oneChat = geminiAi.historyAll[index - 1];
                    return MessageWidget(
                      avathar: oneChat['avathar'],
                      body: oneChat['parts'][0],
                      title: 'nothing',
                      time: DateFormat('h:mm a')
                          .format(DateTime.parse(oneChat['time'])),
                      isBot: oneChat['role'] == 'model',
                    );
                  }
                },
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: geminiAi.historyAll.length + 2);
          })),
          Container(
            color: const Color.fromARGB(255, 228, 228, 228),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: ctrl,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      hintText: geminiAi.historyAll.isEmpty
                          ? 'How can i help you?'
                          : 'Message',
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                  )),
                  IconButton(
                      onPressed: () async {
                        if (ctrl.text.isNotEmpty) {
                          if (geminiAi.historyAll.isEmpty) {
                            var box = await Hive.openBox('local_cubook');
                            geminiAi.historyAll = box.get("history_all") ?? [];
                          }
                          geminiAi.addChat('user', 'account_circle',
                              [ctrl.text], DateTime.now().toString());

                          String prompt = ctrl.text.toString();
                          ctrl.clear();

                          geminiAi.addChat('model', 'star', ["l:o:a:d"],
                              DateTime.now().toString());

                          if (domain == null) {
                            final refAi = await FirebaseDatabase.instance
                                .ref("others/ai_backend/prompt")
                                .get();
                            domain = refAi.value.toString();
                          }

                          var responce = await http.post(Uri.parse(domain!),
                              body: jsonEncode({"prompt": prompt}),
                              headers: {'Content-Type': 'application/json'});

                          geminiAi._historyData.removeLast();

                          String aiConv = responce.statusCode == 200
                              ? responce.body
                              : "Something went wrong!😔";
                          geminiAi.addChat('model', 'star', [aiConv],
                              DateTime.now().toString());

                          var box = await Hive.openBox('local_cubook');
                          box.put('history_all', geminiAi.historyAll);
                        }
                      },
                      icon: const CircleAvatar(
                          backgroundColor: Color(0xFF050F71),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          )))
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

// ignore: must_be_immutable
class MessageWidget extends StatelessWidget {
  MessageWidget({
    super.key,
    required this.avathar,
    required this.title,
    required this.body,
    required this.time,
    required this.isBot,
  });
  final String title;
  String body;
  final String time;
  final bool isBot;
  final String avathar;

  @override
  Widget build(BuildContext context) {
    bool isLoad = body == 'l:o:a:d';

    return Column(
      crossAxisAlignment:
          isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            isBot
                ? SvgPicture.asset("assets/bot.svg",
                    color: Colors.black, width: 30)
                : const SizedBox(),
            Container(
              padding: EdgeInsets.all(isLoad ? 5 : 15),
              constraints: BoxConstraints(
                  maxWidth: (MediaQuery.of(context).size.width / 100 * 75)),
              decoration: ShapeDecoration(
                color: isBot ? Colors.white : const Color(0xFF050F71),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoad
                      ? const SizedBox(
                          width: 60,
                          height: 30,
                          child: DotLoader(),
                        )
                      : bodyManipulate(body, isBot),
                  isLoad ? const SizedBox() : const SizedBox(height: 5),
                  isLoad
                      ? const SizedBox()
                      : Text(
                          time,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFFC6C6C7),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                ],
              ),
            ),
            isBot ? const SizedBox() : const Icon(Icons.account_circle),
          ],
        ),
      ],
    );
  }
}

class DotLoader extends StatelessWidget {
  const DotLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: JumpingDots(
          // innerPadding: 3,
          delay: 3,
          color: Colors.grey,
          radius: 8,
          numberOfDots: 3,
          verticalOffset: 5,
          animationDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}

Widget bodyManipulate(String body, bool isBot) {
  while (body[body.length - 1] == '\n') {
    body = body.substring(0, body.length - 1);
  }

  body = body.replaceAllMapped("\n* ", (match) => "\n• ");

  List<TextSpan> textWid = [];
  List split = body.split("**");
  split.asMap().forEach((key, value) {
    if (key % 2 == 1) {
      textWid.add(TextSpan(
          text: value.toString(),
          style: TextStyle(
            color: isBot ? Colors.black : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 0,
          )));
    } else {
      textWid.add(TextSpan(
          text: value.toString(),
          style: TextStyle(
            color: isBot ? Colors.black : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            height: 0,
          )));
    }
  });

  return Text.rich(textAlign: TextAlign.left, TextSpan(children: textWid));
}

// Text(body.toString(),
//       textAlign: TextAlign.left,
//       style: TextStyle(
//         color: isBot ? Colors.black : Colors.white,
//         fontSize: 13,
//         fontWeight: FontWeight.w400,
//         height: 0,
//       ));