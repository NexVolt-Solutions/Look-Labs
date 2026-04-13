import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Repository/image_upload_repository.dart';

/// Shared step index + optional domain uploads (skincare after API questions).
class ReviewScansViewModel extends ChangeNotifier {
  ReviewScansViewModel({String? uploadDomain})
    : _uploadDomain =
          uploadDomain != null && uploadDomain.trim().isNotEmpty
          ? uploadDomain.trim().toLowerCase()
          : null;

  /// When set (e.g. `skincare`), user must pick 4 photos and [uploadAllDomainImages] runs on Continue.
  final String? _uploadDomain;

  /// Last tapped slot (selection ring). [stepperHighlightStep] drives the top stepper.
  int currentStep = 0;

  /// Local file paths: index order Front, Back, Right, Left (matches UI + API [slotViewKeys]).
  final List<String?> _imagePaths = List<String?>.filled(4, null);

  bool _uploading = false;
  String? _uploadError;

  static const List<String> slotViewKeys = [
    'front',
    'back',
    'right',
    'left',
  ];

  static const List<String> slotLabels = [
    'Front View',
    'Back View',
    'Right View',
    'Left View',
  ];

  static const List<String> stepperStepTitles = [
    'Front',
    'Back',
    'Right',
    'Left',
  ];

  /// First incomplete slot for stepper (check = filled before this index).
  int get stepperHighlightStep {
    for (var i = 0; i < _imagePaths.length; i++) {
      final p = _imagePaths[i];
      if (p == null || p.isEmpty) return i;
    }
    return _imagePaths.length - 1;
  }

  bool get needsDomainUpload => _uploadDomain != null;
  bool get uploading => _uploading;
  String? get uploadError => _uploadError;

  bool get allSlotsFilled =>
      _imagePaths.every((p) => p != null && p.isNotEmpty);

  String? imagePathForSlot(int index) {
    if (index < 0 || index >= _imagePaths.length) return null;
    return _imagePaths[index];
  }

  void selectStep(int step) {
    if (step < 0 || step >= _imagePaths.length) return;
    currentStep = step;
    notifyListeners();
  }

  /// Pick image for [index] from [source] (camera or gallery). No-op if domain upload not required.
  Future<void> pickImageForSlot(int index, ImageSource source) async {
    if (!needsDomainUpload) {
      selectStep(index);
      return;
    }
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: source,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    if (xFile == null) return;
    _imagePaths[index] = xFile.path;
    currentStep = index;
    _uploadError = null;
    notifyListeners();
  }

  /// Upload all four images via POST …/images/upload?domain=&view= (front|back|right|left).
  Future<bool> uploadAllDomainImages() async {
    if (!needsDomainUpload) return true;
    if (!allSlotsFilled) {
      _uploadError = 'Please add a photo for each angle.';
      notifyListeners();
      return false;
    }

    _uploading = true;
    _uploadError = null;
    notifyListeners();

    final domain = _uploadDomain!;
    for (var i = 0; i < _imagePaths.length; i++) {
      final path = _imagePaths[i]!;
      final view = slotViewKeys[i];
      final ApiResponse response =
          await ImageUploadRepository.instance.uploadDomainImage(
            path,
            domain: domain,
            view: view,
          );
      if (!response.success) {
        _uploading = false;
        _uploadError = response.userMessageOrFallback(
          'Upload failed for $view view',
        );
        notifyListeners();
        return false;
      }
    }

    _uploading = false;
    notifyListeners();
    return true;
  }
}
