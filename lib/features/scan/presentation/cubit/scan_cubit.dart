import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';
import 'package:safe_bite/features/scan/domain/usecases/analyze_image_use_case.dart';
import 'package:safe_bite/features/scan/domain/usecases/save_food_items_use_case.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final AnalyzeImageUseCase _analyzeImage;
  final SaveFoodItemsUseCase _saveFoodItems;
  final GetCurrentUserUseCase _getCurrentUser;

  ScanCubit({
    required AnalyzeImageUseCase analyzeImage,
    required SaveFoodItemsUseCase saveFoodItems,
    required GetCurrentUserUseCase getCurrentUser,
  }) : _analyzeImage = analyzeImage,
       _saveFoodItems = saveFoodItems,
       _getCurrentUser = getCurrentUser,
       super(ScanInitial());

  Future<void> analyzeImage(Uint8List imageBytes) async {
    emit(ScanLoading());
    try {
      final result = await _analyzeImage(imageBytes);
      emit(ScanSuccess(result));
    } catch (e) {
      emit(ScanFailure(e.toString()));
    }
  }

  Future<void> saveResults(FoodAnalysis analysis, Uint8List? imageBytes) async {
    try {
      final user = await _getCurrentUser();
      if (user == null) {
        emit(const ScanFailure('User tidak ditemukan. Silakan login ulang.'));
        return;
      }
      await _saveFoodItems(
        userId: user.uid,
        analysis: analysis,
        imageBytes: imageBytes,
      );
      emit(ScanSaved());
    } catch (e) {
      emit(ScanFailure('Failed to save: $e'));
      rethrow;
    }
  }

  void reset() {
    emit(ScanInitial());
  }
}
