import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_page.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../cubit/scan_cubit.dart';
import '../cubit/scan_state.dart';
import '../../domain/entities/food_analysis.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScanCubit(ScanRepositoryImpl()),
      child: const ScanView(),
    );
  }
}

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    // Immediately open camera after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImage(ImageSource.camera);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? pickedFile;
      if (source == ImageSource.camera) {
        // Navigate to Custom Camera Page
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CameraPage()),
        );
        if (result is XFile) {
          pickedFile = result;
        }
      } else {
        // Use default gallery picker
        pickedFile = await _picker.pickImage(source: source);
      }

      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
        if (mounted) {
          context.read<ScanCubit>().analyzeImage(_image!);
        }
      } else {
        // User cancelled camera/gallery, return to previous screen (Home)
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) Navigator.pop(context);
    }
  }

  void _resetScan() {
    setState(() {
      _image = null;
    });
    context.read<ScanCubit>().reset();
    // Re-open camera immediately or pop?
    // Usually "Reset" means "Scan Again".
    // But if they want no fallback UI, maybe we re-trigger picker?
    _pickImage(ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<ScanCubit, ScanState>(
        listener: (context, state) {
          if (state is ScanFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal memindai: ${state.message}')),
            );
            if (mounted) Navigator.pop(context);
          } else if (state is ScanSuccess && !state.result.isFood) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Bukan makanan yang dikenali. Kembali ke beranda...',
                ),
              ),
            );
            if (mounted) Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ScanSuccess && state.result.isFood) {
            return _buildResultView(context, state.result);
          }
          // Show loading or nothing
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6B9F5E)),
          );
        },
      ),
    );
  }

  Widget _buildResultView(BuildContext context, FoodAnalysis data) {
    return Stack(
      children: [
        // 1. Full Image Background
        Positioned.fill(
          child: kIsWeb
              ? Image.network(_image!.path, fit: BoxFit.cover)
              : Image.file(File(_image!.path), fit: BoxFit.cover),
        ),

        // 2. Gradient Overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.4, 1.0],
              ),
            ),
          ),
        ),

        // 3. Close Button
        Positioned(
          top: 50,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _resetScan,
            ),
          ),
        ),

        // 4. Content Card
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title and Category
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.foodName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.category.toUpperCase(), // Displaying Category
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B9F5E),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getFreshnessColor(
                          data.freshnessLevel,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _getFreshnessColor(data.freshnessLevel),
                        ),
                      ),
                      child: Text(
                        data.freshnessLevel,
                        style: TextStyle(
                          color: _getFreshnessColor(data.freshnessLevel),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Shelf Life info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Estimasi Umur Simpan",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            data.shelfLife,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Save Button
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data berhasi disimpan ✅")),
                    );
                    _resetScan();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B9F5E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SIMPAN',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getFreshnessColor(String freshness) {
    final lower = freshness.toLowerCase();
    if (lower.contains('segar') || lower.contains('baik')) return Colors.green;
    if (lower.contains('layak') || lower.contains('cukup'))
      return Colors.orange;
    return Colors.red;
  }
}
