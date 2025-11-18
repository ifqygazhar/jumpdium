import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/core/constant/static_data.dart';
import 'package:jumpdium/core/providers/theme_provider.dart';
import 'package:jumpdium/page/widgets/link_dialog_content.dart';
import 'package:jumpdium/page/widgets/loading_view.dart';
import 'package:jumpdium/page/widgets/not_found_view.dart';

class JumpMediaPage extends StatefulWidget {
  final String link;
  const JumpMediaPage({super.key, required this.link});

  @override
  State<JumpMediaPage> createState() => _JumpMediaPageState();
}

class _JumpMediaPageState extends State<JumpMediaPage> {
  final _random = Random();
  late final int randomKey;
  late TextEditingController _textController;
  late ScrollController _scrollController;

  double _progress = 0;
  InAppWebViewController? webViewController;

  bool isLoading = true;
  bool isNotFound = false;

  static const String URI = String.fromEnvironment('BASE_URL');

  String getSmartJavascript(bool isDarkMode) {
    final bgColor = isDarkMode ? '#1C1C1E' : '#F5F5F5';
    final darkClass = isDarkMode ? 'dark' : 'light';

    return """
      const cloudflareWrapper = document.querySelector('.main-wrapper');
      if (cloudflareWrapper) {
        return 'cloudflare';
      }

      const notFoundElement = Array.from(document.querySelectorAll('p')).find(p => p.textContent.includes('Unable to identify the Medium article URL.'));
      if (notFoundElement) {
        return 'not_found';
      }
      
      document.documentElement.classList.add('$darkClass');
      document.body.style.backgroundColor = '$bgColor';
      
      const header = document.getElementById('header');
      if (header) header.style.display = 'none';
      
      const bypassLink = document.querySelector('a[href*="#bypass"]');
      if (bypassLink) bypassLink.parentElement.style.display = 'none';

      return 'content';
    """;
  }

  void _showLinkDialog() {
    final themeProvider = ThemeProvider.of(context);
    final isDarkMode = themeProvider?.isDarkMode ?? true;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => LinkDialogContent(
        isDarkMode: isDarkMode,
        textController: _textController,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    randomKey = _random.nextInt(loadingImgs.length);
  }

  @override
  void dispose() {
    webViewController?.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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
                // Performance improvements
                forceDark: isDarkMode ? ForceDark.ON : ForceDark.OFF,
                cacheEnabled: true,
                clearCache: false,

                // Rendering optimization
                useHybridComposition: true,
                hardwareAcceleration: true,

                // Resource loading optimization
                domStorageEnabled: true,
                databaseEnabled: true,

                // JavaScript optimization
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: false,

                // Media optimization
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,

                // Network optimization
                useShouldInterceptRequest: false,

                // Viewport optimization
                useWideViewPort: true,
                loadWithOverviewMode: true,

                // Scroll optimization
                verticalScrollBarEnabled: true,
                horizontalScrollBarEnabled: false,

                // Disable unnecessary features
                supportZoom: false,
                builtInZoomControls: false,
                disableContextMenu: true,

                // Security & Privacy (keep only necessary)
                allowFileAccessFromFileURLs: false,
                allowUniversalAccessFromFileURLs: false,
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
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                // Block external navigation for better performance
                final url = navigationAction.request.url;
                if (url != null && !url.toString().contains(URI)) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
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
              onScrollChanged: (controller, x, y) {
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(y.toDouble());
                }
              },
              onLoadError: (controller, url, code, message) {
                // Handle errors gracefully
                if (mounted) {
                  setState(() {
                    isLoading = false;
                    isNotFound = true;
                  });
                }
              },
            ),
          ),

          if (isLoading)
            LoadingView(
              isDarkMode: isDarkMode,
              randomKey: randomKey,
              progress: _progress,
            ),

          if (isNotFound) NotFoundView(isDarkMode: isDarkMode),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showLinkDialog,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add_link, color: Colors.white),
        label: const Text(
          "Jump",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
