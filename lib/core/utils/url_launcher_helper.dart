import 'package:url_launcher/url_launcher.dart';

Future<void> launchChrome(String URI) async {
  final String url = URI;

  try {
    await launch(url, forceSafariVC: false);
  } catch (e) {
    await launch(url, forceSafariVC: false);
  }
}
