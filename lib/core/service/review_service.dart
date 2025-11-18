import 'dart:io';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewService {
  static const String _reviewRequestedKey = 'review_requested';
  static const String _reviewCompletedKey = 'review_completed';
  static const String _appOpenCountKey = 'app_open_count';

  // Ganti dengan ID aplikasi Anda
  static const String _androidPackageName = 'com.yourcompany.jumpdium';
  static const String _iOSAppId = 'your_ios_app_id';

  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> incrementAppOpenCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_appOpenCountKey) ?? 0) + 1;
    await prefs.setInt(_appOpenCountKey, count);
  }

  Future<int> getAppOpenCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_appOpenCountKey) ?? 0;
  }

  Future<bool> hasReviewBeenRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reviewRequestedKey) ?? false;
  }

  Future<void> markReviewAsRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reviewRequestedKey, true);
  }

  Future<bool> hasReviewBeenCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reviewCompletedKey) ?? false;
  }

  Future<void> markReviewAsCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reviewCompletedKey, true);
  }

  Future<bool> shouldShowReviewPrompt() async {
    final count = await getAppOpenCount();
    final requested = await hasReviewBeenRequested();
    final completed = await hasReviewBeenCompleted();

    // Tampilkan review setelah 5x membuka app dan belum pernah direview
    return count >= 5 && !requested && !completed;
  }

  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
      await markReviewAsRequested();
    }
  }

  Future<void> openStoreListing() async {
    if (Platform.isAndroid) {
      final url = Uri.parse(
        'https://play.google.com/store/apps/details?id=$_androidPackageName',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else if (Platform.isIOS) {
      final url = Uri.parse('https://apps.apple.com/app/id$_iOSAppId');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
    await markReviewAsCompleted();
  }
}
