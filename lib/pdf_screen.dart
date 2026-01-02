import 'package:change_case/change_case.dart';
import 'package:edstaq_31_07_2025/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: must_be_immutable
class PdfScreen extends StatefulWidget {
  PdfScreen({super.key, required this.link, required this.title});
  final String link;
  final String title;
  String mode = "Normal Mode";

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  BannerAd? _ad;
  @override
  void initState() {
    super.initState();
    // ...........allowing landcape and portrate..............................
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitIdPdf,
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
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String value = widget.link;

// ....................................................................

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 80),
          child: Container(
            alignment: Alignment.bottomCenter,
            color: (widget.mode == "Normal Mode") //switching read mode
                ? Colors.white
                : Colors.black,
            height: 80,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 30,
                        //switching read mode
                        color: (widget.mode == "Normal Mode" ||
                                widget.mode == "Read Mode")
                            ? const Color(0xFF292E7A)
                            : const Color(0xFFE5E5E5),
                      )),
                  Expanded(
                    child: Text(
                      widget.title.toString().toTitleCase(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //switching read mode
                        color: (widget.mode == "Normal Mode" ||
                                widget.mode == "Read Mode")
                            ? Colors.black
                            : const Color(0xFFE5E5E5),
                        fontSize: 18,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    icon: SvgPicture.asset(
                      "assets/three_dot.svg",
                      width: 20,
                      //switching read mode
                      color: (widget.mode == "Normal Mode" ||
                              widget.mode == "Read Mode")
                          ? const Color(0xFF292E7A)
                          : const Color(0xFFE5E5E5),
                    ),
                    initialValue: widget.mode,
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "Normal Mode", child: Text("Normal Mode")),
                      const PopupMenuItem(
                          value: "Dark Mode", child: Text("Dark Mode")),
                    ],
                    onSelected: (value) {
                      setState(() {
                        widget.mode = value;
                      });
                    },
                  )
                ],
              ),
            ),
          )),
      // ....................................................................

      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            //switching read mode
            child: (widget.mode == "Normal Mode")
                ? PdfNormal(url: value)
                : PdfDark(url: value),
          ),
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
      )),
    );
  }
}

// ..................dark mode pdf..............................................
class PdfDark extends StatelessWidget {
  const PdfDark({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return const PDF(
            autoSpacing: false, swipeHorizontal: false, nightMode: true)
        .cachedFromUrl(url);
  }
}

// ..................normal mode pdf..............................................

class PdfNormal extends StatelessWidget {
  const PdfNormal({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return const PDF(
            autoSpacing: false, swipeHorizontal: false, nightMode: false)
        .cachedFromUrl(url);
  }
}