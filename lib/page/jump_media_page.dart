import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/core/constant/static_data.dart';
import 'package:jumpdium/core/providers/theme_provider.dart';

class JumpMediaPage extends StatefulWidget {
  final String link;
  const JumpMediaPage({super.key, required this.link});

  @override
  State<JumpMediaPage> createState() => _JumpMediaPageState();
}

class _JumpMediaPageState extends State<JumpMediaPage> {
  final _random = Random();
  late final int randomKey;

  double _progress = 0;
  InAppWebViewController? webViewController;

  bool isLoading = true;
  bool isNotFound = false;

  static const String URI = String.fromEnvironment('BASE_URL');

  String getSmartJavascript(bool isDarkMode) {
    final bgColor = isDarkMode ? '#1C1C1E' : '#F5F5F5';
    final darkClass = isDarkMode ? 'dark' : 'light';

    return """
      // Cek halaman verifikasi Cloudflare
      const cloudflareWrapper = document.querySelector('.main-wrapper');
      if (cloudflareWrapper) {
        return 'cloudflare';
      }

      // Cek halaman 'not found' dari server
      const notFoundElement = Array.from(document.querySelectorAll('p')).find(p => p.textContent.includes('Unable to identify the Medium article URL.'));
      if (notFoundElement) {
        return 'not_found';
      }
      
      // Jika bukan keduanya, maka ini halaman konten. Lakukan modifikasi DOM.
      document.documentElement.classList.add('$darkClass');
      document.body.style.backgroundColor = '$bgColor';
      
      const header = document.getElementById('header');
      if (header) header.style.display = 'none';
      
      const bypassLink = document.querySelector('a[href*="#bypass"]');
      if (bypassLink) bypassLink.parentElement.style.display = 'none';

      return 'content';
    """;
  }

  @override
  void initState() {
    super.initState();
    randomKey = _random.nextInt(loadingImgs.length);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider?.isDarkMode ?? true;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: isLoading || isNotFound ? 0.0 : 1.0,
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri("$URI/${widget.link}")),
              initialSettings: InAppWebViewSettings(
                forceDark: isDarkMode ? ForceDark.ON : ForceDark.OFF,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                if (mounted) {
                  setState(() {
                    _progress = progress / 100;
                  });
                }
              },
              onLoadStop: (controller, url) async {
                // Mengevaluasi JavaScript untuk menentukan jenis halaman
                var result = await controller.callAsyncJavaScript(
                  functionBody: getSmartJavascript(isDarkMode),
                );

                if (!mounted) return;

                switch (result?.value) {
                  case 'content':
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                          isNotFound = false;
                        });
                      }
                    });
                    break;
                  case 'not_found':
                    setState(() {
                      isLoading = false;
                      isNotFound = true;
                    });
                    break;
                  case 'cloudflare':
                    setState(() {
                      isLoading = true;
                      isNotFound = false;
                    });
                    break;
                }
              },
            ),
          ),

          if (isLoading)
            Container(
              color: getBackgroundColor(isDarkMode),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      loadingImgs[randomKey]!['img'] as String,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "\"${loadingImgs[randomKey]!['qoute']}\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: getTextColor(isDarkMode).withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Lagi di hek dulu nih...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(isDarkMode).withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 10,
                      backgroundColor: getProgressBackgroundColor(isDarkMode),
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.close, color: getSurfaceColor(isDarkMode)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Stuck lebih dari 1 menit ? close",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: getSurfaceColor(isDarkMode),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (isNotFound)
            Container(
              color: getBackgroundColor(isDarkMode),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    "Oops! Article Not Found",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We couldn't find the Medium article from the link you provided.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: getTextColor(isDarkMode).withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Go Back",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
