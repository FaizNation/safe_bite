import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Password'),
        backgroundColor: const Color(0xFFD4E7C5),
      ),
      body: const Center(
        child: Text('Halaman untuk mengubah password pengguna.'),
      ),
    );
  }
}
