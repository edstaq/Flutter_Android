import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6855577507006829/2879229991';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; //demo ad id for temp
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get bannerAdUnitIdPdf {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6855577507006829/6238276105';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; //demo ad id for temp
    }
    throw UnsupportedError("Unsupported platform");
  }
}