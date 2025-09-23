import 'package:flutter/material.dart';
import 'package:jumpdium/core/constant/colors.dart';
import 'package:jumpdium/page/home.dart';
import 'package:jumpdium/page/widgets/connectivity_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jumpdium',
      theme: ThemeData(scaffoldBackgroundColor: backgroundColor),
      supportedLocales: const [Locale('en', '')],
      locale: const Locale('en', ''),
      home: const ConnectivityWrapper(child: HomePage()),
    );
  }
}
