import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPw extends StatelessWidget {
  ResetPw({super.key});
  final _controller = TextEditingController();

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
              //  title bar
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
                  'Reset Password',
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.next,
                      maxLength: 30,
                      decoration: const InputDecoration(
                        counterText: "",
                        labelText: 'Email',
                        hintText: 'Type Here',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ))),
              const SizedBox(height: 25),
              InkWell(
                onTap: () async {
                  // .........sending reset link.............
                  HapticFeedback.lightImpact();
                  if (EmailValidator.validate(_controller.text)) {
                    // reset email instance
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: _controller.text.trim())
                        .whenComplete(() {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                      scaffoldSnakeBar(context, "Reset email send");
                    }).onError((error, stackTrace) {
                      scaffoldSnakeBar(context, "Enter registered valid email");
                    });
                  } else {
                    scaffoldSnakeBar(context, "Enter registered valid email");
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
                      child: const Text("Send reset link",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                    )),
              )
            ],
          ),
        ),
      )),
    );
  }
}

// .................snakebar messenge funtion.................
void scaffoldSnakeBar(BuildContext context, String massage) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: Text(
        massage,
        style: const TextStyle(color: Colors.white),
      )));
}
