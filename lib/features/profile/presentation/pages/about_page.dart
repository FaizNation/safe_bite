import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Tentang Safe Bite',
          style: TextStyle(
            color: Color(0xFF2D5016),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD4E7C5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2D5016)),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Safe Bite v1.0.0',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Safe Bite adalah aplikasi yang membantu Anda mengelola bahan makanan, melacak tanggal kadaluarsa, dan mengurangi limbah makanan. Kami berkomitmen untuk mendukung gaya hidup berkelanjutan.',
              style: TextStyle(fontSize: 16),
            ),
            // SizedBox(height: 20),
            // Text(
            //   'Tim Pengembang',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 10),
            // Text(
            //   '- Fadly Faiz Fajarruddin\n- Dkk',
            //   style: TextStyle(fontSize: 16),
            // ),
          ],
        ),
      ),
    );
  }
}
