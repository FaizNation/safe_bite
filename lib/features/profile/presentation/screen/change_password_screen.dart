import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

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
