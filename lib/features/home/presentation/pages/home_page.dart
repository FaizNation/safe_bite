import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Welcome to Safe Bite!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5016),
          ),
        ),
      ),
    );
  }
}
