import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  void requestCamera() async {
    _permissionHandler.requestPermissions([PermissionGroup.camera]);
  }
}