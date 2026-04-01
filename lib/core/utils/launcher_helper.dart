import 'package:url_launcher/url_launcher.dart';

class LauncherHelper {
  static Future<void> callPhone(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> launchWebsite(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static Future<void> sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
