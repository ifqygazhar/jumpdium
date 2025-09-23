import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumpdium/core/constant/colors.dart';

void showCopyAddressModal(BuildContext context, String title, String address) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: const Color(0xFF2C2C2E),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                address,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Salin alamat di atas untuk donasi.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tutup', style: TextStyle(color: Colors.grey)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Salin Alamat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: address));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alamat berhasil disalin ke clipboard!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
