import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermission {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted == false && status.isDenied == false) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus;
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      return status;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted == false && status.isDenied == false) {
      PermissionStatus permissionStatus = await Permission.microphone.request();
      return permissionStatus;
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      return status;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if ((cameraPermissionStatus == PermissionStatus.denied ||
            cameraPermissionStatus == PermissionStatus.permanentlyDenied) &&
        (microphonePermissionStatus == PermissionStatus.denied ||
            microphonePermissionStatus == PermissionStatus.permanentlyDenied)) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus != PermissionStatus.granted &&
        microphonePermissionStatus != PermissionStatus.granted) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }
}
