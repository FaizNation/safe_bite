import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      if (mounted) {
        context.read<ScanCubit>().analyzeImage(_image!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Food Scanner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              SizedBox(
                height: 200,
                child: kIsWeb
                    ? Image.network(_image!.path, fit: BoxFit.cover)
                    : Image.file(File(_image!.path), fit: BoxFit.cover),
              )
            else
              Container(
                height: 200,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Text('No Image Selected'),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<ScanCubit, ScanState>(
                builder: (context, state) {
                  if (state is ScanLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ScanFailure) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is ScanSuccess) {
                    return _buildResult(state.result);
                  }
                  return const Center(child: Text('Scan an image to start'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(FoodAnalysis data) {
    if (!data.isFood) {
      return const Center(
        child: Text(
          'Not a food item detected.',
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _resultItem('Name', data.foodName),
          _resultItem('Category', data.category),
          _resultItem('Freshness', data.freshnessLevel),
          _resultItem('Shelf Life', data.shelfLife),
          _resultItem('Storage', data.storageAdvice),
          _resultItem('Calories', '${data.caloriesApprox} kcal'),
          const SizedBox(height: 10),
          const Text(
            'Recipe Idea:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(data.recipeIdea),
        ],
      ),
    );
  }

  Widget _resultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
