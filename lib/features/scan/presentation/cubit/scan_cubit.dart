import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/food_analysis.dart';
import '../../domain/repositories/scan_repository.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final ScanRepository _repository;

  ScanCubit(this._repository) : super(ScanInitial());

  Future<void> analyzeImage(XFile image) async {
    emit(ScanLoading());
    try {
      final result = await _repository.analyzeImage(image);
      emit(ScanSuccess(result));
    } catch (e) {
      emit(ScanFailure(e.toString()));
    }
  }

  Future<void> saveResults(
    String userId,
    FoodAnalysis analysis,
    XFile? imageFile,
  ) async {
    try {
      await _repository.saveFoodItems(userId, analysis, imageFile);
    } catch (e) {
      emit(ScanFailure('Failed to save: $e'));
      rethrow; 
    }
  }

  void reset() {
    emit(ScanInitial());
  }
}
