import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Bantuan & Dukungan',
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
              'Pusat Bantuan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Jika Anda mengalami masalah atau memiliki pertanyaan, silakan hubungi tim dukungan kami.',
              style: TextStyle(fontSize: 16),
            ),
            // SizedBox(height: 20),
            // ListTile(
            //   leading: Icon(Icons.email_outlined),
            //   title: Text('Email'),
            //   subtitle: Text('support@safebite.com'),
            // ),
            // ListTile(
            //   leading: Icon(Icons.phone_outlined),
            //   title: Text('Telepon'),
            //   subtitle: Text('+62 812 3456 7890'),
            // ),
          ],
        ),
      ),
    );
  }
}
