import 'package:change_case/change_case.dart';
import 'package:edstaq_31_07_2025/ad_helper.dart';
import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
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

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  final String title;
  final Map data;
  final Map database;
  final List section = [];
  final List child = [];
  final List path;
  late final List childTitle;
  late final List childLink;
  late final List childType;
  late final List productId;
  List tempItem = [];
  final textController = TextEditingController();

  // .................................................
  ProductScreen(
      {super.key,
      required this.title, // page titile
      required this.path, // path of the page
      required this.data, // question paper:[product ids]
      required this.database // product id details
      }) {
    // print("...............");
    // print(database);
    // .............separating keys and values..................
    for (var element in data.keys) {
      if (database.keys.contains(element)) {
        section.add(element); // keys
        child.add(data[element]); // values
      }
    }
    // .................splitting values into title,link,type, id.............................................
    childTitle = [];
    childLink = [];
    childType = [];
    productId = [];

    for (var parent in section) {
      if (database.keys.contains(parent)) {
        List tempchildTitle = [];
        List tempchildLink = [];
        List tempchildType = [];
        List tempProductId = [];
        for (var kid in child[section.indexOf(parent)]) {
          if ((database[parent] as Map).keys.contains(kid.toString())) {
            Map temp = database[parent][kid.toString()] as Map;
            if (temp.keys.contains("title") &&
                temp.keys.contains("link") &&
                temp.keys.contains("type")) {
              tempProductId.add(kid);
              tempchildTitle.add(database[parent][kid.toString()]["title"]);
              tempchildLink.add(database[parent][kid.toString()]["link"]);
              tempchildType.add(database[parent][kid.toString()]["type"]);
            }
          }
        }
        productId.add(tempProductId);
        childTitle.add(tempchildTitle);
        childLink.add(tempchildLink);
        childType.add(tempchildType);
      }
    }

    tempItem = childTitle; // temitem for  searching content
  }

// ..............................................................
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // ................. ad initializing.............................
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
  //.............................................................................

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                // ......open drawer...........
                                HapticFeedback.lightImpact();
                                FocusScope.of(context).unfocus();
                                Scaffold.of(Utils.mainNavigator.currentContext!)
                                    .openDrawer();
                              },
                              icon: SvgPicture.asset("assets/menu.svg")),
                          Expanded(
                            child: Text(
                              widget.title.toTitleCase(),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 48,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 47,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 23,
                              offset: Offset(0, 2),
                              spreadRadius: -4,
                            )
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: TextField(
                        controller: widget.textController,
                        minLines: 1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  // ........clear search action.............
                                  HapticFeedback.lightImpact();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    widget.textController.clear();
                                    widget.tempItem = [];
                                    for (var element in widget.childTitle) {
                                      widget.tempItem.add(Utils().seo(
                                          widget.textController.text, element));
                                    }
                                  });
                                },
                                icon: const Icon(Icons.clear)),
                            hintText: "Search..."),
                        onChanged: (value) {
                          // .............when search edit happens..........
                          setState(() {
                            widget.textController;
                            widget.tempItem = [];
                            for (var element in widget.childTitle) {
                              widget.tempItem.add(Utils()
                                  .seo(widget.textController.text, element));
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 13),
                    Expanded(
                      child: SizedBox(
                        child: SingleChildScrollView(
                            controller: Utils.scrollControllerProduct,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            child: Column(
                                // screen main column
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: ListView(
                                      controller: ScrollController(
                                          keepScrollOffset: true),
                                      shrinkWrap: true,
                                      children: [
                                        // ..............creating each section..............
                                        ...[
                                          ListView.separated(
                                              controller: ScrollController(
                                                  keepScrollOffset: true),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(height: 13),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      child: Text(
                                                        widget.section[index]
                                                            .toString()
                                                            .toTitleCase(),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    // ...........list of item in a section.............
                                                    CuSectionWidget(
                                                      path: widget.path,
                                                      section:
                                                          widget.section[index],
                                                      productId: widget
                                                          .productId[index],
                                                      fileType: widget
                                                          .childType[index],
                                                      mainTitle: widget
                                                          .childTitle[index],
                                                      mainLink: widget
                                                          .childLink[index],
                                                      tempItem: widget
                                                          .tempItem[index],
                                                      searchString: widget
                                                          .textController.text,
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Divider(height: 0);
                                              },
                                              itemCount: widget.section.length),
                                        ],
                                        // ..............empty notifier...........
                                        ...[
                                          (widget.section.isEmpty)
                                              ? const Center(
                                                  child: Text(
                                                    "No Items Found!",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Color(0xFF292E7A),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                        // .........group of request..............
                                        ...[
                                          RequestSection(
                                            dir: widget.path,
                                          )
                                        ],
                                        // ...............show ad............
                                        ...[
                                          if (_ad != null)
                                            Container(
                                              width: _ad!.size.width.toDouble(),
                                              height: 72.0,
                                              alignment: Alignment.center,
                                              child: AdWidget(ad: _ad!),
                                            )
                                        ],
                                        ...[const SizedBox(height: 30)]
                                      ],
                                    ),
                                  )
                                ])),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}

// .............section for each type of file. eg: youtube,pdf,...
class CuSectionWidget extends StatefulWidget {
  final List path;
  final String searchString;
  final List tempItem;
  final List mainLink;
  final List fileType;
  final List mainTitle;
  final List productId;
  final String section;
  const CuSectionWidget({
    super.key,
    required this.searchString,
    required this.tempItem,
    required this.path,
    required this.mainLink,
    required this.fileType,
    required this.mainTitle,
    required this.productId,
    required this.section,
  });

  @override
  State<CuSectionWidget> createState() => _CuSectionWidgetState();
}

class _CuSectionWidgetState extends State<CuSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListView(
        controller: ScrollController(keepScrollOffset: true),
        shrinkWrap: true,
        children: [
          ...[
            // ............listing each items of a section....................
            ListView.separated(
                controller: ScrollController(keepScrollOffset: true),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final tempIndex = widget.mainTitle.indexOf(widget.tempItem[
                      index]); //////////////index changed to temp index
                  return CuCategoryWidget(
                    path: widget.path,
                    section: widget.section.toString(),
                    proId: widget.productId[tempIndex].toString(),
                    type: widget.fileType[tempIndex],
                    link: widget.mainLink[tempIndex],
                    titleMain: widget.tempItem[index].toString(),
                    hilight: widget.searchString,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                  );
                },
                itemCount: widget.tempItem.length),
          ],
          // ...........empty notifier.........................
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
        ],
      ),
    );
  }
}

// .................single item of a section.....................
// ignore: must_be_immutable
class CuCategoryWidget extends StatelessWidget {
  CuCategoryWidget({
    super.key,
    required this.hilight,
    required this.path,
    required this.titleMain,
    required this.link,
    required this.type,
    required this.proId,
    required this.section,
  });
  final String hilight;
  final String titleMain;
  final String link;
  final List path;
  final String type;
  final String proId;
  final String section;
  bool buttonState = false;

  @override
  Widget build(BuildContext context) {
    // ......checking liked items.................
    String titleSub = type;
    var key = [
      ...["products"],
      ...[section],
      ...[proId]
    ];
    if (Utils.favorited.keys
        .map((e) => e.toString())
        .contains(key.join("!!!"))) {
      buttonState = true;
    }
    // ..........................................
    return InkWell(
      onTap: () async {
        // ..................when single item tapped.....................
        FocusScope.of(context).unfocus();
        HapticFeedback.lightImpact();
        if (FirebaseAuth.instance.currentUser != null) {
          // checking user is authenticated
          await Utils.favoriteDb(
              [
                ...["products"],
                ...[section],
                ...[proId],
                ...["clicks"]
              ].join("/"),
              1); // ..............updating a click of item in database..............
          switch (type) {
            // ................choosing screen by data type...........
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

          //....................  updating a auth user click....................
          FirebaseDatabase.instance
              .ref("user_files")
              .child("log")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({
            DateTime.now().toString().replaceAll(RegExp('[.:]'), "-"): [
              ...path,
              ...[section],
              ...[proId]
            ].join(">>>")
          });
        } else {
          Utils.appNavigator.currentState!.push(
              MaterialPageRoute(builder: (context) => const TempAuthScreen()));
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ListTile(
          trailing: Container(
              width: 33,
              height: 33,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xfff1f1f1)),
              child: FavoriteButton(
                  // favoriteing widget class
                  buttonState: buttonState,
                  path: [
                    ...["products"],
                    ...[section],
                    ...[proId]
                  ],
                  size: 18,
                  mainPath: [
                    ...path,
                    ...[section]
                  ].join(" >> "))),
          horizontalTitleGap: 16,
          minLeadingWidth: 30,
          leading: [
            // ..............swiching icon by data type............
            SvgPicture.asset(
              "assets/youtube.svg",
              fit: BoxFit.fill,
            ),
            SvgPicture.asset(
              "assets/pdf.svg",
              fit: BoxFit.fill,
            ),
          ][(type == "pdf") ? 1 : 0],
          subtitle: Text(titleSub.toLowerCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          title: Text.rich(TextSpan(
              children: seoText(
                  titleMain.toTitleCase(), hilight))), // search color manager
          minVerticalPadding: 0,
        ),
      ),
    );
  }
}

// ................... two types of request contains........................
class RequestSection extends StatelessWidget {
  const RequestSection({super.key, required this.dir});
  final List dir;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const Text(
            'Request',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // .............popup for category submit...................
            showCategorySubmitPopup(context, dir);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListTile(
              trailing: Container(
                  width: 33,
                  height: 33,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF132391), Color(0xFF050F71)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xfff1f1f1)),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.white,
                  )),
              horizontalTitleGap: 16,
              minLeadingWidth: 30,
              leading: const Icon(
                CuIcons.request,
                color: Color(0xFF292E7A),
                size: 30,
              ),
              subtitle: const Text("Request you needed product name",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
              title: const Text("Request by Name",
                  style: TextStyle(
                    color: Color(0xFF292E7A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              minVerticalPadding: 0,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // .............popup for product upload...................
            showGformPopup(context);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListTile(
              trailing: Container(
                  width: 33,
                  height: 33,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF132391), Color(0xFF050F71)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xfff1f1f1)),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.white,
                  )),
              horizontalTitleGap: 16,
              minLeadingWidth: 30,
              leading: const Icon(
                CuIcons.request,
                color: Color(0xFF292E7A),
                size: 30,
              ),
              subtitle: const Text("Request by uploading your products ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
              title: const Text("Request by Product",
                  style: TextStyle(
                    color: Color(0xFF292E7A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              minVerticalPadding: 0,
            ),
          ),
        )
      ],
    );
  }
}

// ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// ignore: must_be_immutable
class FavoriteButton extends StatefulWidget {
  FavoriteButton(
      {super.key,
      this.size = 10,
      this.buttonState = false,
      required this.path,
      required this.mainPath});
  bool buttonState;
  bool loadState = false;
  final double size;
  final List path;
  final String mainPath;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    var keyy = widget.path;

    return Center(
        child: IconButton(
      color: Colors.black,
      iconSize: widget.size,
      onPressed: () async {
        HapticFeedback.lightImpact();

// ..............................................................
        if (FirebaseAuth.instance.currentUser != null) {
          String favDbPath = [
            ...widget.path,
            ...["favorited"]
          ].join("/");
// ..............................................................
          // ............ configuring like state................
          if (widget.buttonState == true) {
            widget.loadState = true;

            final rtdb = FirebaseDatabase.instance
                .ref("user_files")
                .child("favorits")
                .child(FirebaseAuth.instance.currentUser!.uid)
                .child(keyy.join("!!!"));
            rtdb.remove().whenComplete(() {
              setState(() {
                widget.loadState = false;
                Utils.favoriteDb(favDbPath, -1);
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
            widget.loadState = true;

            final rtdb = FirebaseDatabase.instance
                .ref("user_files")
                .child("favorits")
                .child(FirebaseAuth.instance.currentUser!.uid);

            rtdb.update({keyy.join("!!!"): widget.mainPath}).whenComplete(() {
              setState(() {
                widget.loadState = false;
                widget.buttonState = !widget.buttonState;
                Utils.favoriteDb(favDbPath, 1);
                Utils.favorited[keyy.join("!!!")] = widget.mainPath; //temp
              });
            }).onError((error, stackTrace) {
              setState(() {
                widget.loadState = false;
              });
            });
          }
        } else {
          Utils.appNavigator.currentState!.push(
              MaterialPageRoute(builder: (context) => const TempAuthScreen()));
        }
      },
      icon: [
        const Icon(CuIcons.heart),
        const Icon(CuIcons.heartEmpty),
        const CircularProgressIndicator()
      ][(widget.loadState)
          ? 2
          : (widget.buttonState)
              ? 0
              : 1],
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
