import 'package:flutter/material.dart';

class AboutExpiredScreen extends StatelessWidget {
  const AboutExpiredScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Bahan Kadaluarsa'),
        backgroundColor: const Color(0xFFD4E7C5),
      ),
      body: const Center(
        child: Text('Halaman informasi tentang bahan kadaluarsa.'),
      ),
    );
  }
}
