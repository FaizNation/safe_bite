import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraPermissionDenied extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;
  final FlashMode flashMode;
  final bool isFrontCamera;

  const CameraReady({
    required this.controller,
    required this.flashMode,
    required this.isFrontCamera,
  });

  @override
  List<Object?> get props => [controller, flashMode, isFrontCamera];
}

class CameraCaptureSuccess extends CameraState {
  final XFile image;

  const CameraCaptureSuccess(this.image);

  @override
  List<Object?> get props => [image];
}

class CameraError extends CameraState {
  final String message;

  const CameraError(this.message);

  @override
  List<Object?> get props => [message];
}
