import 'package:change_case/change_case.dart';
import 'package:edstaq_31_07_2025/ad_helper.dart';
import 'package:edstaq_31_07_2025/ai_assistant.dart';
import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/other_widgets.dart';
import 'package:edstaq_31_07_2025/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {
  final List mainItem = [];
  final List subTitle = [];
  final List child = [];
  List tempItem = [];
  List path = [];
  String title;
  Map data;
  final textController = TextEditingController();

  CategoryScreen(
      {super.key,
      required this.title,
      required this.data,
      required this.path}) {
    for (var element in data.keys) {
      mainItem.add(element); // listing data keys

      // ................calculating sub directory count......................
      Map temp = (data[element] is Map) ? data[element] : {};
      bool isEveryMap = true;
      temp.forEach((key, value) {
        if (value is List) {
          isEveryMap = false;
        }
      });
      int count = 0; // count for product items
      if (!isEveryMap) {
        for (var element in temp.values) {
          count += (element as List).length;
        }
      }

      subTitle.add((!isEveryMap) ? count : temp.length);
      child.add(temp);
    }
    tempItem =
        mainItem; // create a duplicate variable for key for search activity
  }
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // .............banner ad initialize......................
  BannerAd? _ad;
  @override
  void initState() {
    super.initState();

    // ......................................

    //  Load a banner ad
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

  // ......................................

  @override
  void dispose() {
    _ad?.dispose();

    super.dispose();
  }
  // ........................................................

  @override
  Widget build(BuildContext context) {
    Utils.scrollControllerCategory =
        ScrollController(); // nead to remove but it makes error
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
            child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              //......................top area...................
              SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          HapticFeedback.lightImpact();
                          Scaffold.of(Utils.mainNavigator.currentContext!)
                              .openDrawer();
                        },
                        icon: SvgPicture.asset("assets/menu.svg")),
                    IconButton(
                        onPressed: () async {
                          var box = await Hive.openBox('local_cubook');
                          List histAll = box.get("history_all") ?? [];
                          HapticFeedback.lightImpact();
                          // ignore: use_build_context_synchronously
                          FocusScope.of(context).unfocus();
                          Utils.appNavigator.currentState!.push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(hist: histAll),
                                  fullscreenDialog: true));
                        },
                        icon: AiIcon())
                  ],
                ),
              ),
              AnimatedBuilder(
                  animation: Utils.scrollControllerCategory,
                  builder: (context, snapshot) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: (Utils.scrollControllerCategory.hasClients)
                          ? (Utils.scrollControllerCategory.position.pixels >=
                                  10)
                              ? 0
                              : 13
                          : 13,
                    );
                  }),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: AnimatedBuilder(
                    animation: Utils.scrollControllerCategory,
                    builder: (context, snapshot) {
                      return AnimatedDefaultTextStyle(
                          style: TextStyle(
                            letterSpacing: -2,
                            color: Colors.black,
                            fontSize: Utils.scrollControllerCategory.hasClients
                                ? Utils.scrollControllerCategory.position
                                            .pixels >=
                                        10
                                    ? 22
                                    : 34
                                : 34,
                            fontFamily: "Nunitosans",
                            fontWeight: FontWeight.w700,
                          ),
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            widget.title.toTitleCase(),
                            maxLines: 1,
                          ));
                    }),
              ),
              const SizedBox(height: 13),
              Container(
                //
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
                    controller: Utils.scrollControllerCategory,
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
                            controller:
                                ScrollController(keepScrollOffset: true),
                            shrinkWrap: true,
                            children: [
                              // .........no item notify.................
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
                              // ................listing all items..............
                              ...[
                                ListView.separated(
                                    controller: ScrollController(
                                        keepScrollOffset: true),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return CuCategoryWidget(
                                        path: widget.path,
                                        child: widget.child[widget.mainItem
                                            .indexOf(widget.tempItem[index])],
                                        title: widget.tempItem[index],
                                        subtitle:
                                            "${widget.subTitle[widget.mainItem.indexOf(widget.tempItem[index])]} items",
                                        highlight: widget.textController.text,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 0);
                                    },
                                    itemCount: widget.tempItem.length),
                              ],
                              // ................request........................
                              ...[CuCategoryWidgetSp(dir: widget.path)],
                              // ................showing ad here........................
                              ...[
                                if (_ad != null)
                                  Container(
                                    width: _ad!.size.width.toDouble(),
                                    height: 72.0,
                                    alignment: Alignment.center,
                                    child: AdWidget(ad: _ad!),
                                  )
                              ],
                              ...[const SizedBox(height: 20)]
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
      ),
    );
  }
}

class CuCategoryWidget extends StatelessWidget {
  const CuCategoryWidget(
      {super.key,
      required this.title,
      required this.path,
      required this.subtitle,
      required this.child,
      required this.highlight});
  final String title;
  final String subtitle;
  final String highlight;
  final List path;
  final Map child;

  @override
  Widget build(BuildContext context) {
    // ...........choosing category/Product.......................
    bool isCategoryScn = true;
    if (child.isNotEmpty) {
      if (child.values.any((element) => element is List)) {
        isCategoryScn = false;
      }
    }

    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        HapticFeedback.lightImpact();

        List tPath = [
          ...path,
          ...[title]
        ];

        if (!isCategoryScn) {
          if (Utils.productList.isEmpty) {
            showProcessPopup(context);
            final ref = FirebaseDatabase.instance.ref('products');
            final snapshot = await ref.get();
            Utils.appNavigator.currentState!.pop();
            Utils.productList = snapshot.value as Map;
          }
          if (Utils.productList.isNotEmpty) {
            Utils.mainNavigator.currentState!.pushNamed("/category/product",
                arguments: {
                  "title": title,
                  "child": child,
                  "database": Utils.productList,
                  "path": tPath
                });
          }
        } else {
          Utils.mainNavigator.currentState!.pushNamed("/category",
              arguments: {"title": title, "child": child, "path": tPath});
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
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.black,
              )),
          horizontalTitleGap: 16,
          minLeadingWidth: 30,
          leading: SvgPicture.asset(
            "assets/file.svg",
            fit: BoxFit.fill,
          ),
          subtitle: Text(subtitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          title: Text.rich(
              TextSpan(children: seoText(title.toTitleCase(), highlight))),
          minVerticalPadding: 0,
        ),
      ),
    );
  }
}

class CuCategoryWidgetSp extends StatelessWidget {
  const CuCategoryWidgetSp({super.key, required this.dir});
  final List dir;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        showCategorySubmitPopup(context, dir); // pop up for request from user
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
          subtitle: const Text("Request not in your list you needed",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          title: const Text("Request",
              style: TextStyle(
                color: Color(0xFF292E7A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          minVerticalPadding: 0,
        ),
      ),
    );
  }
}

// .....................code for hilight search key word.......................
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
