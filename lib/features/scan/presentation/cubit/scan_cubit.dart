import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/scan_repository.dart';
import 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final ScanRepository _repository;

  ScanCubit(this._repository) : super(ScanInitial());

  Future<void> analyzeImage(File image) async {
    emit(ScanLoading());
    try {
      final result = await _repository.analyzeImage(image);
      emit(ScanSuccess(result));
    } catch (e) {
      emit(ScanFailure(e.toString()));
    }
  }

  void reset() {
    emit(ScanInitial());
  }
}
