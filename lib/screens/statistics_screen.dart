import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null, // No AppBar to match the design
      body: Center(
        child: Text('Statistics Screen'),
      ),
    );
  }
}
