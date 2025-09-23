import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late StreamSubscription<InternetStatus> _subscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();

    _subscription = InternetConnection().onStatusChange.listen((status) {
      final bool isOfflineNow = status == InternetStatus.disconnected;

      if (isOfflineNow != _isOffline) {
        setState(() {
          _isOffline = isOfflineNow;
        });
        _showConnectivitySnackBar();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _showConnectivitySnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            _isOffline ? Icons.wifi_off : Icons.wifi,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),

          Text(
            _isOffline ? 'Tidak ada koneksi internet' : 'Kembali online',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      backgroundColor: _isOffline
          ? const Color.fromARGB(255, 223, 107, 98)
          : const Color.fromARGB(255, 101, 225, 105),
      duration: _isOffline
          ? const Duration(days: 1)
          : const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
