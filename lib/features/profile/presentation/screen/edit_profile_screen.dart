import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Profil'),
        backgroundColor: const Color(0xFFD4E7C5),
      ),
      body: const Center(
        child: Text('Halaman untuk mengubah profil pengguna.'),
      ),
    );
  }
}
