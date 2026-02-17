import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:safe_bite/core/utils/app_logger.dart';
import 'package:safe_bite/features/scan/data/datasources/scan_remote_data_source.dart';
import 'package:safe_bite/features/scan/data/models/food_analysis_model.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';
import 'package:safe_bite/features/scan/domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanRemoteDataSource _remoteDataSource;

  ScanRepositoryImpl({required ScanRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<FoodAnalysis> analyzeImage(Uint8List imageBytes) {
    return _remoteDataSource.analyzeImage(imageBytes);
  }

  @override
  Future<void> saveFoodItems(
    String userId,
    FoodAnalysis analysis,
    Uint8List? imageBytes,
  ) async {
    Uint8List? compressedImage;
    if (imageBytes != null) {
      try {
        final image = img.decodeImage(imageBytes);
        if (image != null) {
          final resized = img.copyResize(image, width: 600);
          compressedImage = Uint8List.fromList(
            img.encodeJpg(resized, quality: 70),
          );
        }
      } catch (e) {
        AppLogger.error('Error processing image for Firestore blob: $e');
      }
    }

    final analysisModel = FoodAnalysisModel(
      isFood: analysis.isFood,
      items: analysis.items,
    );

    return _remoteDataSource.saveFoodItems(
      userId,
      analysisModel,
      compressedImage,
    );
  }
}
