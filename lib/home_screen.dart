import 'dart:convert';

import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edstaq_31_07_2025/ad_helper.dart';
import 'package:edstaq_31_07_2025/ai_assistant.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
import 'package:edstaq_31_07_2025/utils.dart';
// import 'package:enhanced_url_launcher/enhanced_url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final List mainItem;
  List tempItem = [];
  final List icons;
  final List child;
  final Map posterData;
  HomeScreen(
      {super.key,
      required this.mainItem,
      required this.icons,
      required this.posterData,
      required this.child}) {
    tempItem = mainItem;
  }
  var textController = TextEditingController();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ...........................ad initialize...........................
  BannerAd? _ad;
  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad?.dispose();

    super.dispose();
  }

  void redirectToUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle the error
      debugPrint("Could not launch $url");
    }
  }

  // ...................................................................

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero).then((value) async {
      final List parameters = [
        "name",
        "institute_name",
        "institute_place",
        "institute_district",
        "mobile_number"
      ];
      var box = await Hive.openBox('local_cubook');
      List aiChatHist = box.get('history_all') ?? [];
      Map aiUserParamVal = {};

      Map data = {};
      if (FirebaseAuth.instance.currentUser != null) {
        final firebase = await FirebaseDatabase.instance
            .ref("users")
            .child(FirebaseAuth.instance.currentUser!.uid.toString())
            .get();
        data = (firebase.value as Map);
      }

      for (var element in parameters) {
        if (data.containsKey(element)) {
          if (data.containsKey(element)) {
            aiUserParamVal[element] = data[element];
          }
        }
      }
      List aiChatHist2 = [];
      for (Map element in aiChatHist) {
        Map temp = {};
        element.forEach(
          (key, value) {
            if (key == 'role') {
              temp[key] = value;
            } else if (key == 'parts') {
              temp[key] = value;
            }
          },
        );
        aiChatHist2.add(temp);
      }

      final refAi =
          await FirebaseDatabase.instance.ref("others/ai_backend/init").get();
      http.post(Uri.parse(refAi.value.toString()),
          body: jsonEncode(
              {"about_user": aiUserParamVal, "init_history": aiChatHist2}),
          // ignore: avoid_print
          headers: {
            'Content-Type': 'application/json'
            // ignore: avoid_print
          }).then((value) => print(value.statusCode));
    });
    return Scaffold(
      body: SafeArea(
          child: Center(
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
                  IconButton(
                      onPressed: () async {
                        var box = await Hive.openBox('local_cubook');
                        List histAll = box.get("history_all") ?? [];

                        HapticFeedback.lightImpact();
                        // ignore: use_build_context_synchronously
                        FocusScope.of(context).unfocus();
                        Utils.appNavigator.currentState!.push(MaterialPageRoute(
                            builder: (context) => ChatScreen(hist: histAll),
                            fullscreenDialog: true));
                      },
                      icon: AiIcon())
                ],
              ),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
                animation: Utils.scrollcontrollerHome,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                          width: MediaQuery.of(context).size.width * 0.9,
                          alignment: Alignment.center,
                          duration: const Duration(milliseconds: 300),
                          height: (Utils.scrollcontrollerHome.hasClients)
                              ? (129 -
                                          Utils.scrollcontrollerHome.position
                                              .pixels <
                                      0)
                                  ? 0
                                  : 129 -
                                      Utils.scrollcontrollerHome.position.pixels
                              : 129,
                          child: AnotherCarousel(
                              // ...............Banner slider configration............................
                              dotSize: 5,
                              dotSpacing: 15,
                              dotIncreaseSize: 1.1,
                              dotBgColor: const Color.fromARGB(0, 0, 0, 0),
                              dotIncreasedColor: Colors.black,
                              indicatorBgPadding: 8,
                              dotVerticalPadding: 1,
                              borderRadius: true,
                              boxFit: BoxFit.fitHeight,
                              radius: const Radius.circular(20),
                              autoplayDuration: const Duration(seconds: 7),
                              onImageTap: (index) {
                                print(index);
                                redirectToUrl(widget.posterData.values
                                    .toList()[index]["redirect"]);
                              },
                              images: List.generate(
                                widget.posterData.length,
                                (index) => Container(
                                    height: 162,
                                    width: 360,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: CachedNetworkImageProvider(
                                                widget
                                                        .posterData.values
                                                        .toList()[index]
                                                    ["imagelink"])),
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black)),
                              ))),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: (Utils.scrollcontrollerHome.hasClients)
                            ? (Utils.scrollcontrollerHome.position.pixels >= 10)
                                ? 0
                                : 13
                            : 13,
                      )
                    ],
                  );
                }),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 47,
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 23,
                  offset: Offset(0, 2),
                  spreadRadius: -4,
                )
              ], borderRadius: BorderRadius.circular(15), color: Colors.white),
              child: TextField(
                controller: widget.textController,
                minLines: 1,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                        onPressed: () {
                          // ................clear search.......................
                          HapticFeedback.lightImpact();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            widget.textController.clear();
                            widget.tempItem = Utils().seo(
                                widget.textController.text, widget.mainItem);
                          });
                        },
                        icon: const Icon(Icons.clear)),
                    hintText: "Search..."),
                onChanged: (value) {
                  // ...................change edit........................
                  setState(() {
                    widget.textController;
                    widget.tempItem = Utils()
                        .seo(widget.textController.text, widget.mainItem);
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  controller: Utils.scrollcontrollerHome,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      // ...................note if empty list..................
                      ...[
                        (widget.tempItem.isEmpty)
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
                      ],
                      // ...............grid of the screen........................
                      ...[
                        GridView.count(
                            // Grid configaration
                            controller:
                                ScrollController(keepScrollOffset: true),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 17,
                            crossAxisSpacing: 16,
                            padding: const EdgeInsets.all(20),
                            children: [
                              //generating grids to Grid list
                              ...List.generate(widget.tempItem.length, (index) {
                                return CuMainGrid(
                                  child: widget.child[widget.mainItem
                                      .indexOf(widget.tempItem[index])],
                                  imageLink: widget.icons[widget.mainItem
                                      .indexOf(widget.tempItem[index])],
                                  titleMain: widget.tempItem[index],
                                  hilight: widget.textController.text,
                                );
                              }),
                              ...[const CuMainGridRequest()]
                            ]),
                        //.................. show ads....................
                        ...[
                          if (_ad != null)
                            Container(
                              width: _ad!.size.width.toDouble(),
                              height: 72.0,
                              alignment: Alignment.center,
                              child: AdWidget(ad: _ad!),
                            )
                        ]
                      ],
                      const SizedBox(
                        height: 100,
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
// .....................each Grid button....................................

class CuMainGrid extends StatelessWidget {
  const CuMainGrid(
      {super.key,
      required this.titleMain,
      required this.child,
      required this.hilight,
      required this.imageLink});
  final String hilight;
  final String imageLink;
  final String titleMain;
  final Map child;

  @override
  Widget build(BuildContext context) {
    //  ..........checking category or not......................
    bool mode = true;
    if (child.isNotEmpty) {
      if (child.values.any((element) => element is List)) {
        mode = false;
      }
    }
    return Center(
      child: InkWell(
        highlightColor: const Color.fromARGB(0, 0, 0, 0),
        onTap: () async {
          HapticFeedback.lightImpact();
          Utils.scrollcontrollerHome.jumpTo(0);
          FocusScope.of(context).unfocus();
          if (!mode) {
            if (Utils.productList.isEmpty) {
              final ref = FirebaseDatabase.instance.ref('products');
              final snapshot = await ref.get();
              Utils.productList = snapshot.value as Map;
            }
            if (Utils.productList.isNotEmpty) {
              Utils.mainNavigator.currentState!
                  .pushNamed("/category/product", arguments: {
                "title": titleMain,
                "child": child,
                "database": Utils.productList,
                "path": [titleMain]
              });
            }
          } else {
            Utils.mainNavigator.currentState!
                .pushNamed("/category", arguments: {
              "title": titleMain,
              "child": child,
              "path": [titleMain]
            });
          }
        },
        child: Container(
          width: 174,
          height: 154,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 11,
                offset: Offset(2, 4),
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.center,
                        width: 67,
                        child: CachedNetworkImage(
                          imageUrl: imageLink,
                          fit: BoxFit.contain,
                        ))),
                Expanded(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                        child: Text.rich(
                          TextSpan(
                              children:
                                  // ................update text color..................
                                  seoText(titleMain.toUpperCase(), hilight)),
                          textAlign: TextAlign.center,
                        ))),
              ]),
        ),
      ),
    );
  }
}
// .....................Request Button....................................

class CuMainGridRequest extends StatelessWidget {
  const CuMainGridRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        showCategorySubmitPopup(context, []);
      },
      child: Center(
        child: Container(
          width: 174,
          height: 154,
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF132391), Color(0xFF050F71)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 11,
                offset: Offset(2, 4),
                spreadRadius: 1,
              )
            ],
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.center,
                        width: 67,
                        child: SvgPicture.asset("assets/request.svg"))),
                Expanded(
                    flex: 1,
                    child: Container(
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                        child: const Text(
                          "Request",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ))),
              ]),
        ),
      ),
    );
  }
}

// code for hilight search key word....................................
List<InlineSpan> seoText(String text, String hilight) {
  hilight = hilight.trim();
  int start = 0;
  int len = text.length;
  int jump = hilight.length;
  int times = len + 1 - jump;
  List splitted = [];
  bool flag = true;

  for (var i = 0; i < times; i++) {
    String colored = text.substring(start, i + jump);

    if (colored.toLowerCase() == hilight.toLowerCase()) {
      splitted.add(colored);
      start += jump;
      flag = false;
    } else {
      if (flag && i == times - 1) {
        splitted.add(text.substring(start, start + jump));
      } else {
        splitted.add(text.substring(start, start + 1));
      }

      start++;
    }
  }

  List<InlineSpan> widgetList = [];

  for (var element in splitted) {
    if (element.toString().toLowerCase() == hilight.toLowerCase()) {
      widgetList.add(TextSpan(
          text: element,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 0,
          )));
    } else {
      widgetList.add(TextSpan(
          text: element,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 0,
          )));
    }
  }
  if (splitted.isEmpty) {
    widgetList.add(TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 0,
        )));
  }
  return widgetList;
}
