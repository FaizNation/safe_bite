import 'package:flutter/material.dart';
import '../features/scan/presentation/pages/scan_page.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We can directly return the ScanPage here
    return const ScanPage();
  }
}
