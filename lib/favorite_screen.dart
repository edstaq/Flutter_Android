import 'package:change_case/change_case.dart';
import 'package:edstaq_31_07_2025/ad_helper.dart';
import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/pdf_screen.dart';
import 'package:edstaq_31_07_2025/temp_auth_screen.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:edstaq_31_07_2025/youtube_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marquee/marquee.dart';

// ignore: must_be_immutable
class FavoriteScreen extends StatefulWidget {
  late List mainItem;
  late List tempItem;
  List subtitle = [];
  List title = [];
  List type = [];
  List link = [];
  List tKey = [];
  FavoriteScreen({super.key}) {
    // ..........checking auth and favorited list.....................
    if (Utils.favorited.isNotEmpty &&
        FirebaseAuth.instance.currentUser != null) {
      // ..................splitting data ............................
      for (var element in Utils.favorited.keys) {
        subtitle.add(Utils.favorited[element]);
        dynamic newElement = element.toString().split("!!!");
        tKey.add(newElement);
        title.add(Utils.productList[newElement[1]][newElement[2]]["title"]);
        type.add(Utils.productList[newElement[1]][newElement[2]]["type"]);
        link.add(Utils.productList[newElement[1]][newElement[2]]["link"]);
      }
    } else {
      subtitle = [];
      title = [];
      type = [];
      link = [];
      tKey = [];
    }

    mainItem = title;
    tempItem = mainItem;
  }
  var textController = TextEditingController();

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  // .................banner ad setup.........................
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
  // ..............................................................

  @override
  Widget build(BuildContext context) {
    // .............resetting data.................................
    if (FirebaseAuth.instance.currentUser == null) {
      widget.mainItem = [];
      widget.tempItem = [];
      widget.subtitle = [];
      widget.title = [];
      widget.type = [];
      widget.link = [];
      widget.tKey = [];
    }
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
                      icon: SvgPicture.asset("assets/menu.svg"))
                ],
              ),
            ),
            AnimatedBuilder(
                animation: Utils.scrollcontrollerFavorite,
                builder: (context, snapshot) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: (Utils.scrollcontrollerFavorite.hasClients)
                        ? (Utils.scrollcontrollerFavorite.position.pixels >= 10)
                            ? 0
                            : 13
                        : 13,
                  );
                }),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: AnimatedBuilder(
                  animation: Utils.scrollcontrollerFavorite,
                  builder: (context, snapshot) {
                    return AnimatedDefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Utils.scrollcontrollerFavorite.hasClients
                              ? Utils.scrollcontrollerFavorite.position
                                          .pixels >=
                                      10
                                  ? 22
                                  : 34
                              : 34,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w700,
                        ),
                        duration: const Duration(milliseconds: 300),
                        child:const Text('Favotites'));
                  }),
            ),
            const SizedBox(height: 13),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 47,
              decoration: BoxDecoration(boxShadow:const [
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
                    prefixIcon:const  Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                        onPressed: () {
                          // clearing search.............................
                          HapticFeedback.lightImpact();
                          FocusScope.of(context).unfocus();
                          setState(() {
                            widget.textController.clear();
                            widget.tempItem = Utils().seo(
                                widget.textController.text, widget.mainItem);
                          });
                        },
                        icon:const  Icon(Icons.clear)),
                    hintText: "Search..."),
                onChanged: (value) {
                  // ...............state changing while edit................
                  setState(() {
                    widget.textController;
                    widget.tempItem = Utils()
                        .seo(widget.textController.text, widget.mainItem);
                  });
                },
              ),
            ),
            const SizedBox(height: 13),
            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  controller: Utils.scrollcontrollerFavorite,
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
                            // generating list of data........................
                            ...[
                              ListView.separated(
                                  controller:
                                      ScrollController(keepScrollOffset: true),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return CuCategoryWidget(
                                      tKey: widget.tKey[widget.mainItem
                                          .indexOf(widget.tempItem[index])],
                                      type: widget.type[widget.mainItem
                                          .indexOf(widget.tempItem[index])],
                                      link: widget.link[widget.mainItem
                                          .indexOf(widget.tempItem[index])],
                                      subTitle: widget.subtitle[widget.mainItem
                                          .indexOf(widget.tempItem[index])],
                                      titleMain: widget.tempItem[index],
                                      hilight: widget.textController.text,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      height: 0,
                                    );
                                  },
                                  itemCount: widget.tempItem.length),
                            ],
                            ...[const 
                              SizedBox(
                                height: 20,
                              )
                            ],
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
                            // ........showing ad......................
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

class CuCategoryWidget extends StatelessWidget {
  const CuCategoryWidget(
      {super.key,
      required this.hilight,
      required this.link,
      required this.type,
      required this.subTitle,
      required this.tKey,
      required this.titleMain});
  final String hilight;
  final String titleMain;
  final String link;
  final String subTitle;
  final String type;
  final List tKey;

  @override
  Widget build(BuildContext context) {
    String subtitle = subTitle;
    int typeCode = 1;
    switch (type) {
      case "pdf":
        typeCode = 1;

        break;

      case "youtube":
        typeCode = 0;

        break;
      default:
        typeCode = 1;
    }
    return InkWell(
      onTap: () async {
        HapticFeedback.lightImpact();
        FocusScope.of(context).unfocus();
        // ..............navigating by decitions.........................
        switch (type) {
          case "pdf":
            {
              Navigator.of(Utils.appNavigator.currentContext!)
                  .push(MaterialPageRoute(
                      builder: (context) => PdfScreen(
                            title: titleMain,
                            link: link,
                          )));
              break;
            }

          case "youtube":
            {
              if (await Utils.checkInappYoutube()) {
                Navigator.of(Utils.appNavigator.currentContext!)
                    .push(MaterialPageRoute(
                        builder: (context) => YoutubeScreen(
                              url: link,
                            )));
              } else {
                await Launcher().launch(link);
              }
              break;
            }
        }
        // ....................................................
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListTile(
          trailing: Container(
              width: 33,
              height: 33,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color:const Color(0xfff1f1f1)),
              child: FavoriteButton(
                path: tKey,
                mainPath: subtitle,
                buttonState: false,
                size: 18,
              )),
          horizontalTitleGap: 16,
          minLeadingWidth: 30,
          leading: [
            SvgPicture.asset(
              "assets/youtube.svg",
              fit: BoxFit.fill,
            ),
            SvgPicture.asset(
              "assets/pdf.svg",
              fit: BoxFit.fill,
            ),
          ][typeCode], //swiching icons
          subtitle: SizedBox(
            height: 15,
            child: (subtitle.length > 26)
                ? Marquee(
                    velocity: 15.0,
                    pauseAfterRound: Duration.zero,
                    blankSpace: 30,
                    text: subtitle.toTitleCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ))
                : Text(subtitle.toTitleCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    )),
          ),
          title: Text.rich(
              TextSpan(children: seoText(titleMain.toTitleCase(), hilight))),
          minVerticalPadding: 0,
        ),
      ),
    );
  }
}

// ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


// ignore: must_be_immutable
class FavoriteButton extends StatefulWidget {
  FavoriteButton(
      {super.key,
      this.size = 10,
      this.buttonState = true,
      required this.path,
      required this.mainPath});
  bool buttonState;
  bool loadState = false;
  double size;
  List path;
  String mainPath;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    List keyy = widget.path;
    // ..............changing firebase data format....................
    if (Utils.favorited.keys
        .map((e) => e.toString())
        .contains(keyy.join("!!!"))) {
      widget.buttonState = true;
    }
    return Center(
        child: IconButton(
      color: Colors.black,
      iconSize: widget.size,
      onPressed: () async {
        HapticFeedback.lightImpact();

        if (FirebaseAuth.instance.currentUser != null) {
          String favDbPath = [
            ...widget.path,
            ...["favorited"]
          ].join("/"); // creating a root of  prodect for favotite
          if (widget.buttonState == true) {
            widget.loadState = true;
// ..............................................................

            final rtdb = FirebaseDatabase.instance
                .ref("user_files")
                .child("favorits")
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child(keyy.join("!!!"));//!!! it useed to create a key from list
            rtdb.remove().whenComplete(() {
              setState(() {
                widget.loadState = false;
                Utils.favoriteDb(favDbPath, -1); // it is a funtion for increment/decrement of single variable in RDBMS
                widget.buttonState = !widget.buttonState;
                Utils.favorited.removeWhere(
                    (key, value) => key.toString() == keyy.join("!!!")); //temp
              });
            }).onError((error, stackTrace) {
              setState(() {
                widget.loadState = false;
              });
            });
// ..............................................................
          } else if (widget.buttonState == false) {
            widget.loadState = true;//favorite loading variable

            final rtdb = FirebaseDatabase.instance
                .ref("user_files")
                .child("favorits")
                .child(FirebaseAuth.instance.currentUser!.uid); 
            rtdb.update({keyy.join("!!!"): widget.mainPath}).whenComplete(() {
              setState(() {
                widget.loadState = false; //favorite loading variable
                widget.buttonState = !widget.buttonState;
                Utils.favoriteDb(favDbPath, 1);// it is a funtion for increment/decrement of single variable in RDBMS
                Utils.favorited[keyy.join("!!!")] = widget.mainPath; //adding path to static variable
              });
            }).onError((error, stackTrace) {
              setState(() {
                widget.loadState = false;
              });
            });
          }
        } else {
          // signed out screen
          Utils.appNavigator.currentState!
              .push(MaterialPageRoute(builder: (context) => const TempAuthScreen()));
        }

      },
      icon: [
        const Icon(CuIcons.heart),
        const Icon(CuIcons.heartEmpty)
      ][(widget.buttonState) ? 0 : 1],
    ));
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )));
    } else {
      widgetList.add(TextSpan(
          text: element,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )));
    }
  }
  if (splitted.isEmpty) {
    widgetList.add(TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )));
  }
  return widgetList;
}