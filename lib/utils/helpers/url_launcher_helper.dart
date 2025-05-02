import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncherHelper {
  static Future<void> openURL(String url,
      {LaunchMode mode = LaunchMode.externalApplication}) async {
    final Uri url0 = Uri.parse(url);
    try {
      if (!await launchUrl(url0)) {
        throw Exception('Could not launch $url0');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
