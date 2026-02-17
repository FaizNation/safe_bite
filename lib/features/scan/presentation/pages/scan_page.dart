import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_bite/features/scan/presentation/cubit/scan_cubit.dart';
import 'package:safe_bite/features/scan/presentation/cubit/scan_state.dart';
import 'camera_page.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScanView();
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
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImage(ImageSource.camera);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? pickedFile;
      if (source == ImageSource.camera) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CameraPage()),
        );
        if (result is XFile) {
          pickedFile = result;
        }
      } else {
        pickedFile = await _picker.pickImage(source: source);
      }

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _image = pickedFile;
          _imageBytes = bytes;
        });
        if (mounted) {
          context.read<ScanCubit>().analyzeImage(bytes);
        }
      } else {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      AppLogger.error('Error picking image: $e');
      if (mounted) Navigator.pop(context);
    }
  }

  void _resetScan() {
    setState(() {
      _image = null;
      _imageBytes = null;
    });
    context.read<ScanCubit>().reset();
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

          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6B9F5E)),
          );
        },
      ),
    );
  }

  Widget _buildResultView(BuildContext context, FoodAnalysis data) {
    final items = data.items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Berhasil di scan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _resetScan,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade100,
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _buildCutout(item.boundingBox),
                              ),
                            ),
                            if (item.quantity > 1)
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'x${item.quantity}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.foodName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Exp : ${item.shelfLife}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildFreshnessIcon(item.freshnessLevel),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  AppLogger.info("Button 'Simpan' PRESSED!");
                  try {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (c) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    await context.read<ScanCubit>().saveResults(
                      data,
                      _imageBytes,
                    );

                    if (context.mounted) Navigator.pop(context);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Semua data berhasil disimpan ✅"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _resetScan();
                    }
                  } catch (e, stack) {
                    AppLogger.error(
                      "CRITICAL ERROR IN SAVE",
                      error: e,
                      stackTrace: stack,
                    );

                    if (context.mounted && Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Gagal Menyimpan"),
                          content: Text("Error: $e"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF558B49),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCutout(List<int>? box) {
    if (box == null || box.length < 4) {
      return kIsWeb
          ? Image.network(_image!.path, fit: BoxFit.cover)
          : Image.file(File(_image!.path), fit: BoxFit.cover);
    }

    final double ymin = box[0] / 1000.0;
    final double xmin = box[1] / 1000.0;
    final double ymax = box[2] / 1000.0;
    final double xmax = box[3] / 1000.0;

    final double w = xmax - xmin;
    final double h = ymax - ymin;

    if (w <= 0 || h <= 0) return Image.file(File(_image!.path));

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: Align(
            alignment: Alignment(
              ((xmin + w / 2) * 2) - 1,
              ((ymin + h / 2) * 2) - 1,
            ),
            widthFactor: w,
            heightFactor: h,
            child: kIsWeb
                ? Image.network(_image!.path, fit: BoxFit.cover)
                : Image.file(File(_image!.path), fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildFreshnessIcon(String freshness) {
    final lower = freshness.toLowerCase();
    Color color;
    IconData icon;

    if (lower.contains('segar') || lower.contains('baik')) {
      color = const Color(0xFF558B49);
      icon = Icons.check_circle_outline;
    } else if (lower.contains('busuk') || lower.contains('buruk')) {
      color = const Color(0xFFD32F2F);
      icon = Icons.error_outline;
    } else {
      color = const Color(0xFFFBC02D);
      icon = Icons.info_outline;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
