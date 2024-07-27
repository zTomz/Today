import 'package:gaimon/gaimon.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();

  factory VibrationService() => _instance;

  VibrationService._internal();

  bool isVibrationOn = true;

  Future<void> init() async {
    // TODO: If the user will have settings in the future, maybe load vibration setting here
    isVibrationOn = await Gaimon.canSupportsHaptic;
  }

  /// The default vibration. Used when the user need's just a smooth feedback
  void vibrate() {
    if (isVibrationOn) {
      Gaimon.light();
    }
  }

  /// The success vibration
  void success() {
    if (isVibrationOn) {
      Gaimon.success();
    }
  }

  /// The warning vibration
  void warning() {
    if (isVibrationOn) {
      Gaimon.warning();
    }
  }

  /// The selection vibration
  void selection() {
    if (isVibrationOn) {
      Gaimon.selection();
    }
  }
}
