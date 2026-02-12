import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi/Instruksi'),
        backgroundColor: const Color(0xFFD4E7C5),
      ),
      body: const Center(
        child: Text('Halaman untuk mengatur notifikasi dan instruksi.'),
      ),
    );
  }
}
