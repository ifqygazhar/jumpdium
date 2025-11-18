import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/core/constant/static_data.dart';
import 'package:jumpdium/core/providers/theme_provider.dart';
import 'package:jumpdium/core/service/review_service.dart';
import 'package:jumpdium/core/utils/popup.dart';
import 'package:jumpdium/core/utils/url_launcher_helper.dart';
import 'package:jumpdium/page/jump_media_page.dart';
import 'package:jumpdium/page/widgets/social_card.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _reviewService = ReviewService();
  late final String randomBanner;
  String _appVersion = '';
  bool isMediumLink = true;

  @override
  void initState() {
    super.initState();
    randomBanner = imgBanners[Random().nextInt(imgBanners.length)];
    _initPackageInfo();
    _checkAndShowReviewPrompt();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = 'v${info.version}';
      });
    }
  }

  Future<void> _checkAndShowReviewPrompt() async {
    await _reviewService.incrementAppOpenCount();

    if (await _reviewService.shouldShowReviewPrompt()) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showReviewDialog();
        }
      });
    }
  }

  void _showReviewDialog() {
    final isDarkMode = ThemeProvider.of(context)?.isDarkMode ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: getSurfaceColor(isDarkMode),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 28),
            const SizedBox(width: 8),
            Text(
              'Enjoying Jumpdium?',
              style: TextStyle(
                color: getTextColor(isDarkMode),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Would you like to rate us? It helps us improve the app!',
          style: TextStyle(
            color: getTextColor(isDarkMode).withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _reviewService.markReviewAsCompleted();
            },
            child: const Text('Not Now', style: TextStyle(color: hintColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _reviewService.requestReview();
              // Tampilkan opsi store setelah review
              _showStoreOptionDialog();
            },
            child: const Text(
              'Rate App',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStoreOptionDialog() {
    final isDarkMode = ThemeProvider.of(context)?.isDarkMode ?? true;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: getSurfaceColor(isDarkMode),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Thank You! 🎉',
            style: TextStyle(
              color: getTextColor(isDarkMode),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Would you like to leave a detailed review on the store?',
            style: TextStyle(
              color: getTextColor(isDarkMode).withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Maybe Later',
                style: TextStyle(color: hintColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _reviewService.openStoreListing();
              },
              child: const Text(
                'Go to Store',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildLinkTypeSelector(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: getSurfaceColor(isDarkMode),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildOptionButton(
              label: "Medium",
              icon: Icons.article,
              isSelected: isMediumLink,
              isDarkMode: isDarkMode,
              onTap: () {
                setState(() {
                  isMediumLink = true;
                });
              },
            ),
          ),
          Expanded(
            child: _buildOptionButton(
              label: "Other Link",
              icon: Icons.public,
              isSelected: !isMediumLink,
              isDarkMode: isDarkMode,
              onTap: () {
                setState(() {
                  isMediumLink = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : hintColor, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : getTextColor(isDarkMode),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider?.isDarkMode ?? true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getBackgroundColor(isDarkMode),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: getTextColor(isDarkMode),
            ),
            onPressed: () {
              themeProvider?.toggleTheme(!isDarkMode);
            },
          ),
          IconButton(
            icon: Icon(Icons.star_border, color: getTextColor(isDarkMode)),
            onPressed: _showReviewDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 40),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        randomBanner,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Link Type Selector
                  _buildLinkTypeSelector(isDarkMode),

                  // Search Field with Send Button
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            color: getTextColor(isDarkMode),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: isMediumLink
                                ? "Paste a Medium link..."
                                : "Paste any article link...",
                            hintStyle: TextStyle(
                              color: hintColor.withValues(alpha: 0.7),
                            ),
                            filled: true,
                            fillColor: getSurfaceColor(isDarkMode),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          final link = _searchController.text.trim();

                          if (link.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please paste a link first."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (isMediumLink && !link.contains("medium.com")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please enter a valid Medium.com link.",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JumpMediaPage(
                                link: link,
                                isMediumLink: isMediumLink,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.send, size: 24),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "Sample just tap! :",
                    style: TextStyle(
                      color: getTextColor(isDarkMode),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                ]),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList.builder(
                itemCount: testingURLs.length,
                itemBuilder: (context, index) {
                  final url = testingURLs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JumpMediaPage(
                              link: url,
                              isMediumLink:
                                  true, // Sample URLs are Medium links
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: getSurfaceColor(isDarkMode),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link, color: hintColor, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                url,
                                style: TextStyle(
                                  color: getTextColor(isDarkMode),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SocialCardWidget(
                          icon: Icons.code,
                          onTap: () => launchChrome(
                            "https://github.com/ifqygazhar/jumpdium",
                          ),
                        ),
                        SocialCardWidget(
                          icon: Icons.person_2_rounded,
                          onTap: () => launchChrome(
                            "https://www.linkedin.com/in/ifqygazhar/",
                          ),
                        ),
                        SocialCardWidget(
                          icon: Icons.coffee,
                          onTap: () =>
                              launchChrome("https://saweria.co/ifqygazhar"),
                        ),
                        SocialCardWidget(
                          icon: Icons.currency_bitcoin_rounded,
                          onTap: () => showCopyAddressModal(
                            context,
                            "Bitcoin (BTC)",
                            "bc1q3dddkn9z8ayh69ha3zmtkfuacqan0w4kvlhns3",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Made with 💙 by ifqy gifha azhar",
                      style: TextStyle(
                        color: hintColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$_appVersion - $currentYear",
                      style: TextStyle(
                        color: hintColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
