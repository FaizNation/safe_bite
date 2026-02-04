import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  FlashMode _currentFlashMode = FlashMode.off;

  Future<void> initCamera() async {
    try {
      emit(CameraLoading());
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        emit(const CameraError("No cameras found"));
        return;
      }

      await _initializeController(_cameras[_selectedCameraIndex]);
    } catch (e) {
      emit(CameraError("Failed to initialize camera: $e"));
    }
  }

  Future<void> _initializeController(
    CameraDescription cameraDescription,
  ) async {
    final previousController = _controller;

    if (previousController != null) {
      await previousController.dispose();
    }

    final newController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      _controller = newController;
      await newController.initialize();

      try {
        await newController.setFlashMode(_currentFlashMode);
      } catch (_) {
        _currentFlashMode = FlashMode.off;
      }

      emit(
        CameraReady(
          controller: newController,
          flashMode: _currentFlashMode,
          isFrontCamera:
              cameraDescription.lensDirection == CameraLensDirection.front,
        ),
      );
    } catch (e) {
      emit(CameraError("Error initializing camera controller: $e"));
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeController(_cameras[_selectedCameraIndex]);
  }

  Future<void> toggleFlash() async {
    final state = this.state;
    if (state is! CameraReady || _controller == null) return;

    final newMode = _currentFlashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;

    try {
      await _controller!.setFlashMode(newMode);
      _currentFlashMode = newMode;
      emit(
        CameraReady(
          controller: _controller!,
          flashMode: newMode,
          isFrontCamera: state.isFrontCamera,
        ),
      );
    } catch (e) {
      // Ignore flash errors (e.g. not supported)
    }
  }

  Future<void> takePicture() async {
    final state = this.state;
    if (state is! CameraReady ||
        _controller == null ||
        !_controller!.value.isInitialized)
      return;

    try {
      final XFile image = await _controller!.takePicture();
      emit(CameraCaptureSuccess(image));
    } catch (e) {
      emit(CameraError("Failed to take picture: $e"));
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
