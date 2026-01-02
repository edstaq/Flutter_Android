// import 'package:enhanced_url_launcher/enhanced_url_launcher_string.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  // height: 218,
                  child: Image.asset("assets/update_image.png")),
              const Text("UPDATE",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF292E7A))),
              const Text("Your app is outdated. \nPlease update to new Version",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const SizedBox(height: 40),
              InkWell(
                onTap: () async {
                  // ...................launching to the play store......................
                  await launchUrlString(
                      "https://play.google.com/store/apps/details?id=com.asrgroup.cuguide&pcampaignid=web_share",
                      mode: LaunchMode.externalApplication);
                },
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF132391), Color(0xFF050F71)],
                        )),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text("Update Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    )),
              ),
            ],
          ),
        )));
  }
}
