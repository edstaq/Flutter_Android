import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// .....................get directory of each location..........................
class Directory {
  static List directory = [];
}


class Utils {
  static Map formUserDetails = {};// save profile details
  static String lastseen = "";//save lastseen while user enter to app
  static bool islogin = false;// state of user logined or not
  static late Map homeData;//parameters of Home page
  static Map favorited = {};//favorite items
  static Map productList = {};//question papers and other type data details
  static Map earnInfoBackup = {};//earning page list details
  static Map notificationBackup = {}; //notification page list details

  // ......................global keys for Navigator and drawer.................
  
  static GlobalKey<NavigatorState> mainNavigator = GlobalKey();
  static GlobalKey<NavigatorState> appNavigator = GlobalKey();
  static GlobalKey<NavigatorState> drawNavigator = GlobalKey();

  // ............................scroll controller..............................

  static late ScrollController scrollcontrollerHome;
  static late ScrollController scrollcontrollerFavorite;
  static late ScrollController scrollcontrollerEarn;
  static late ScrollController scrollcontrollerNotify;
  static late ScrollController scrollControllerCategory;
  static late ScrollController scrollControllerProduct;
  static late ScrollController scrollcontrollerProfile;

  //  ..........................search engine...................................
  
  List seo(String text, List lst) {
    text = text.trim();
    List result = [];
    for (var item in lst) {
      if (text.isEmpty) {
        result.add(item);
      } else if (item.toString().toLowerCase().contains(text.toLowerCase())) {
        result.add(item);
      }
    }
    return result;
  }

  //  ..................youtube inapp checker ..................................
  static Future<bool> checkInappYoutube() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return (androidInfo.version.sdkInt >= 20) ? true : false;
    } catch (e) {
      return false;
    }
  }

  // ..............increment or decreament a integet value in database...
  static Future<void> favoriteDb(String path, int increament) async {
    int? statusType;
    DatabaseReference ref = FirebaseDatabase.instance.ref(path);
    await ref.runTransaction((Object? value) {
      if (value == null) {
        return Transaction.abort();
      }
      statusType = (value as int);
      return Transaction.success(int.parse(value.toString()) + increament);
    });
    if (statusType is! int) {
      ref.set(0);
    }
  }
}

// ...............convert time diff into good format...................
String timeDiff(String from, DateTime to) {
  var fromDate = DateTime.parse(from);
  var diff = to.difference(fromDate);
  String result = "";

  if (diff.inDays == 0) {
    result = "Today";
  } else if (diff.inDays < 30) {
    result = "${diff.inDays} days ago ";
  } else if (diff.inDays < 365) {
    result = "${diff.inDays ~/ 30} months ago";
  } else if (diff.inDays >= 365) {
    result = "${diff.inDays ~/ 365} year ago";
  } else {
    result = "N/A";
  }

  return result;
}