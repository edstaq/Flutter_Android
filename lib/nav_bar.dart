import 'package:edstaq_31_07_2025/auth_screen.dart';
import 'package:edstaq_31_07_2025/category_screen.dart';
import 'package:edstaq_31_07_2025/complaint_screen.dart';
import 'package:edstaq_31_07_2025/cu_icons.dart';
import 'package:edstaq_31_07_2025/earn_info_screen.dart';
import 'package:edstaq_31_07_2025/favorite_screen.dart';
import 'package:edstaq_31_07_2025/feedback_screen.dart';
import 'package:edstaq_31_07_2025/home_screen.dart';
import 'package:edstaq_31_07_2025/notify_screen.dart';
import 'package:edstaq_31_07_2025/product_screen.dart';
import 'package:edstaq_31_07_2025/profile_screen.dart';
import 'package:edstaq_31_07_2025/rateus_popup.dart';
import 'package:edstaq_31_07_2025/temp_auth_screen.dart';
import 'package:edstaq_31_07_2025/utils.dart';
// import 'package:enhanced_url_launcher/enhanced_url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NavBar extends StatefulWidget {
  NavBar({
    super.key,
    required this.titles,
    required this.icons,
    required this.posterData,
    required this.children,
  });
  final List titles;
  final List icons;
  final List children;
  final Map posterData;
  int pageIndex = 2;
  bool drawerStatus = false;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  void initState() {
    // initialize scroll controllers
    super.initState();
    Utils.scrollcontrollerEarn = ScrollController();
    Utils.scrollcontrollerFavorite = ScrollController();
    Utils.scrollcontrollerHome = ScrollController();
    Utils.scrollcontrollerNotify = ScrollController();
    Utils.scrollcontrollerProfile = ScrollController();
    Utils.scrollControllerCategory = ScrollController();
    Utils.scrollControllerProduct = ScrollController();
    // Listening to scroll controller to switch scroll controller
    Utils.scrollcontrollerEarn.addListener(() {
      if (widget.pageIndex != 0) {
        setState(() {
          widget.pageIndex = 0;
        });
      }
    });
    Utils.scrollcontrollerFavorite.addListener(() {
      if (widget.pageIndex != 1) {
        setState(() {
          widget.pageIndex = 1;
        });
      }
    });
    Utils.scrollcontrollerHome.addListener(() {
      if (widget.pageIndex != 2) {
        setState(() {
          widget.pageIndex = 2;
        });
      }
    });
    Utils.scrollcontrollerNotify.addListener(() {
      if (widget.pageIndex != 3) {
        setState(() {
          widget.pageIndex = 3;
        });
      }
    });
    Utils.scrollcontrollerProfile.addListener(() {
      if (widget.pageIndex != 4) {
        setState(() {
          widget.pageIndex = 4;
        });
      }
    });
    Utils.scrollControllerCategory.addListener(() {
      if (widget.pageIndex != 5) {
        setState(() {
          widget.pageIndex = 5;
        });
      }
    });
    Utils.scrollControllerProduct.addListener(() {
      if (widget.pageIndex != 6) {
        setState(() {
          widget.pageIndex = 6;
        });
      }
    });
  }

  // disposing all scroll controllers while need to dispose
  @override
  void dispose() {
    Utils.scrollcontrollerEarn.dispose();
    Utils.scrollcontrollerFavorite.dispose();
    Utils.scrollcontrollerHome.dispose();
    Utils.scrollcontrollerNotify.dispose();
    Utils.scrollcontrollerProfile.dispose();
    Utils.scrollControllerCategory.dispose();
    Utils.scrollControllerProduct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool flag = true; // will pop scope variable
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Utils.islogin = false; //sign info variable
        Utils.favorited = {}; //making empty favorits while loged out
        Utils.formUserDetails = {}; // resetting profile data
      } else {
        Utils.islogin = true;
        // .............getting favorited data.............................
        FirebaseDatabase.instance
            .ref("user_files")
            .child("favorits")
            .child(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) {
              var tempFavotied = ((value.value ?? {}) as Map).map((key, value) {
                dynamic newKey = key.toString();
                return MapEntry(newKey, value);
              });
              Utils.favorited = tempFavotied;
            });

        // ............getting product full product data from firebase..........
        if (Utils.productList.isEmpty) {
          final ref = FirebaseDatabase.instance.ref('products');
          ref.get().then((value) {
            Utils.productList = value.value as Map;
          });
        }

        // ...........updating last seen........................................
        if (Utils.lastseen.isEmpty) {
          Utils.lastseen = DateTime.now().toString();
          FirebaseDatabase.instance
              .ref("users")
              .child(FirebaseAuth.instance.currentUser!.uid)
              .update({"lastseen": DateTime.now().toString()});
        }
      }
    });
    // ..................................................

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // ..........nested nav, drawer, tabs pop management...................
        try {
          //.............. if drawer opened................................
          Scaffold.of(Utils.drawNavigator.currentContext!).isDrawerOpen;
        } catch (e) {
          // .............if not open drawer it make error. then...............
          if (Utils.mainNavigator.currentState != null) {
            if (Utils.mainNavigator.currentState!.canPop()) {
              Utils.mainNavigator.currentState!.pop();
              flag = false;
              Future.delayed(
                const Duration(milliseconds: 500),
              ).then((value) => flag = true);
            } else if (widget.pageIndex == 2) {
              if (flag) {
                flag = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Color(0xFFFFFFFF),
                    content: Text(
                      "Tap again to close the app",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
                Future.delayed(
                  const Duration(seconds: 1),
                ).then((value) => flag = true);
              } else if (!flag) {
                flag = true;
              }
            }
          } else if (widget.pageIndex != 2) {
            setState(() {
              widget.pageIndex = 2;
              flag = false;
            });
          }
        }

        return flag;
      },
      // ........................................................
      child: GestureDetector(
        onTap: () {
          //.............closing keyboard.......................
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
            FocusScope.of(context).nextFocus();
          }
        },
        child: Scaffold(
          drawer: const DrawerClass(),
          bottomNavigationBar: AnimatedBuilder(
            //.................navigation bar with animation.................
            animation: [
              Utils.scrollcontrollerEarn,
              Utils.scrollcontrollerFavorite,
              Utils.scrollcontrollerHome,
              Utils.scrollcontrollerNotify,
              Utils.scrollcontrollerProfile,
              Utils.scrollControllerCategory,
              Utils.scrollControllerProduct,
            ][widget.pageIndex],
            child: Container(
              width: screenWidth,
              height: 89,
              decoration: const ShapeDecoration(
                color: Color(0xFFE5E5E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                  ),
                ),
              ),
              child: Center(
                child: Container(
                  width: screenWidth * 0.95,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(39.50),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth * 0.9,
                      child: GNav(
                        selectedIndex: (widget.pageIndex > 4)
                            ? 2
                            : widget.pageIndex,
                        activeColor: Colors.white,
                        // selected icon and text color
                        tabBorderRadius: 50,
                        tabBackgroundGradient: const LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [Color(0xFF132391), Color(0xFF050F71)],
                        ),
                        iconSize: 20, // tab button icon size
                        color: Colors.black, // unselected icon color
                        gap: 6, // the tab button gap between icon and text
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        curve: Curves.bounceInOut,
                        // tab animation curves
                        duration: const Duration(milliseconds: 300),

                        // tab animation duration
                        tabShadow: const [
                          BoxShadow(color: Color(0xFFE5E5E5)),
                        ], // tab button shadow
                        tabs: [
                          GButton(
                            icon: CuIcons.money,
                            text: 'Earn',
                            onPressed: () {
                              if (widget.pageIndex != 0) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  widget.pageIndex = 0;
                                });
                              }
                            },
                          ),
                          GButton(
                            icon: CuIcons.heart,
                            text: 'Favorite',
                            onPressed: () {
                              if (widget.pageIndex != 1) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  widget.pageIndex = 1;
                                });
                              }
                            },
                          ),
                          GButton(
                            icon: CuIcons.home,
                            text: 'Home',
                            onPressed: () {
                              if (widget.pageIndex != 2) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  widget.pageIndex = 2;
                                });
                              }
                            },
                          ),
                          GButton(
                            icon: CuIcons.notificationFill,
                            text: 'Notify',
                            onPressed: () {
                              if (widget.pageIndex != 3) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  widget.pageIndex = 3;
                                });
                              }
                            },
                          ),
                          GButton(
                            icon: CuIcons.profile,
                            text: 'Profile',
                            onPressed: () {
                              if (widget.pageIndex != 4) {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  widget.pageIndex = 4;
                                });
                                if (!Utils.islogin) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TempAuthScreen(),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                        haptic: false, // haptic feedback
                      ),
                    ),
                  ),
                ),
              ),
            ),
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height:
                    [
                          Utils.scrollcontrollerEarn,
                          Utils.scrollcontrollerFavorite,
                          Utils.scrollcontrollerHome,
                          Utils.scrollcontrollerNotify,
                          Utils.scrollcontrollerProfile,
                          Utils.scrollControllerCategory,
                          Utils.scrollControllerProduct,
                        ][widget.pageIndex].position.pixels >=
                        10
                    ? 0
                    : 80,
                child: child,
              );
            },
          ),
          // ..........switching screens by its state.......................
          body: [
            EarnmonyScreen(),
            FavoriteScreen(),
            NestedNav(
              children: widget.children,
              titles: widget.titles,
              icons: widget.icons,
              posterData: widget.posterData,
            ),
            NotificationScreen(),
            const ProfileScreen(),
            NestedNav(
              children: widget.children,
              titles: widget.titles,
              icons: widget.icons,
              posterData: widget.posterData,
            ),
            NestedNav(
              children: widget.children,
              titles: widget.titles,
              icons: widget.icons,
              posterData: widget.posterData,
            ),
          ][widget.pageIndex],
        ),
      ),
    );
  }
}

// ..........................side menu drawer building.........................
class DrawerClass extends StatefulWidget {
  const DrawerClass({super.key});
  @override
  State<DrawerClass> createState() => _DrawerClassState();
}

class _DrawerClassState extends State<DrawerClass> {
  List redirectionItems = [];

  @override
  void initState() {
    super.initState();
    fetchRedirectionList();
  }

  void fetchRedirectionList() async {
    final ref = FirebaseDatabase.instance.ref('others/redirection_list');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        redirectionItems = data.entries.map((e) {
          final map = e.value as Map;
          return {'title': map['title'], 'link': map['link']};
        }).toList();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        Utils.islogin = false;
      });
    } else {
      setState(() {
        Utils.islogin = true;
      });
    }
    return Drawer(
      key: Utils.drawNavigator,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff132391), Color(0xff050F71)],
                ),
                color: Colors.amber,
              ),
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: SvgPicture.asset(
                      "assets/white_logo.svg",
                      width: 250,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Text(
                      ' Version 3.0',
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          const SizedBox(height: 13),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            horizontalTitleGap: -3,
            leading: const Icon(
              CuIcons.shareOutline,
              color: Colors.black,
              size: 20,
            ),
            title: const Text(
              "Share",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () async {
              final ref = FirebaseDatabase.instance.ref('others');
              final snapshot = await ref.get();
              final data = snapshot.value as Map;
              SharePlus.instance.share(
                ShareParams(
                  text:
                      "EDSTAQ" +
                      "\n" +
                      data["sharetext"].toString().replaceAll("#", "\n") +
                      "\n" +
                      data["sharelink"],
                ),
              );

              // await FlutterShare.share(
              //     title: "EDSTAQ",
              //     text: data["sharetext"].toString().replaceAll("#", "\n"),
              //     linkUrl: data["sharelink"]);
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            horizontalTitleGap: -3,
            leading: const Icon(
              CuIcons.feedback,
              color: Colors.black,
              size: 20,
            ),
            title: const Text(
              "Feedback",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => FeedbackScreen()));
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            horizontalTitleGap: -3,
            leading: const Icon(
              Icons.report_problem_outlined,
              color: Colors.black,
              size: 20,
            ),
            title: const Text(
              "Complaint",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ComplaintScreen()),
              );
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            horizontalTitleGap: -3,
            leading: const Icon(CuIcons.rateing, color: Colors.black, size: 20),
            title: const Text(
              "Rate us",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              rateusPopup(context);
            },
          ),

          // ................dynamic button.. from database......................
          ...redirectionItems.map(
            (e) => ListTile(
              contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              horizontalTitleGap: -3,
              leading: const Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.black,
                size: 20,
              ),
              title: Text(
                e['title'],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {
                Scaffold.of(context).closeDrawer();
                redirectToUrl(e['link']);
              },
            ),
          ),
          // ..........................................................
          (Utils.islogin)
              ? ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  horizontalTitleGap: -3,
                  leading: const Icon(
                    CuIcons.svgrepoIconcarrier,
                    color: Colors.red,
                    size: 20,
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () async {
                    try {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                    } catch (e) {
                      await FirebaseAuth.instance.signOut();
                    }

                    // ignore: use_build_context_synchronously
                    Scaffold.of(context).closeDrawer();
                  },
                )
              : ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  horizontalTitleGap: -3,
                  leading: const Icon(
                    CuIcons.svgrepoIconcarrier,
                    color: Colors.green,
                    size: 20,
                  ),
                  title: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                    Scaffold.of(context).closeDrawer();
                  },
                ),
        ],
      ),
    );
  }
}

// .........making zig-zag container.............
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height * 0.9393586);
    path_0.cubicTo(
      size.width * 0.9395571,
      size.height * 0.9813434,
      size.width * 0.7518857,
      size.height * 1.040116,
      size.width * 0.4847393,
      size.height * 0.9393586,
    );
    path_0.cubicTo(
      size.width * 0.2175943,
      size.height * 0.8386010,
      size.width * 0.05026929,
      size.height * 0.9378030,
      0,
      size.height,
    );
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// .......................NESTED NAVIGATION building............................
// this is the head of nested navigation in the EDSTAQ

class NestedNav extends StatelessWidget {
  const NestedNav({
    super.key,
    required this.titles,
    required this.icons,
    required this.posterData,
    required this.children,
  });
  final List titles;
  final List icons;
  final List children;
  final Map posterData;
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Utils.mainNavigator,
      initialRoute: "/",
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case "/":
            {
              page = HomeScreen(
                mainItem: titles,
                icons: icons,
                child: children,
                posterData: posterData,
              );
              break;
            }
          case "/category":
            {
              Map arg = settings.arguments as Map;
              var title = arg["title"];
              var child = arg["child"];
              var path = arg["path"];

              page = CategoryScreen(path: path, title: title, data: child);
              break;
            }
          case "/category/product":
            {
              Map arg = settings.arguments as Map;
              var title = arg["title"];
              var child = arg["child"];
              var path = arg["path"];
              var database = arg["database"];
              page = ProductScreen(
                title: title,
                data: child,
                database: database,
                path: path,
              );
              break;
            }
          default:
            {
              page = HomeScreen(
                mainItem: titles,
                icons: icons,
                child: children,
                posterData: posterData,
              );
            }
        }
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
              ),
              child: child,
            );
          },
        );
      },
    );
  }
}
