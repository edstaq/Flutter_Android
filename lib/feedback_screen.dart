import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({super.key});
  bool empty = false;

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          // screen main column
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Row(
                children: [
                  IconButton(
                      // back button
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
                'Feedback',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: const Text("Comment",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Type here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                )),
            const SizedBox(height: 13),
            (widget.empty)
                ? const Text(
                    "Field is empty!. write your feedback.",
                    style: TextStyle(color: Colors.red),
                  )
                : const SizedBox(),
            InkWell(
              onTap: () async {
                if (_controller.text.isNotEmpty) {
                  setState(() {
                    widget.empty = false;
                  });
                  // upload to database
                  DatabaseReference categoryRef =
                      FirebaseDatabase.instance.ref("feedback");
                  String date = DateTime.now().toString();
                  String key = date.replaceAll(RegExp('[.:]'),
                      "-"); //replacing for upload to database key
                  await categoryRef.update({key: _controller.text});
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    widget.empty = true;
                  });
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
                          colors: [Color(0xFF132391), Color(0xFF050F71)],
                        )),
                    child: const Text("Send",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
