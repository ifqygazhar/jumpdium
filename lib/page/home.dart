import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/core/constant/static_data.dart';
import 'package:jumpdium/core/providers/theme_provider.dart';
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
  late final String randomBanner;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    randomBanner = imgBanners[Random().nextInt(imgBanners.length)];
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = 'v${info.version}';
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                            hintText: "Paste a Medium link...",
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
                          if (link.isNotEmpty) {
                            if (link.contains("medium.com")) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JumpMediaPage(link: link),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter a valid Medium.com link.",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please paste a link first."),
                              ),
                            );
                          }
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
                  const SizedBox(height: 50),
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
                            builder: (context) => JumpMediaPage(link: url),
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
