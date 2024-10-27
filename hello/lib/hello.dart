
import 'hello_platform_interface.dart';

class Hello {
  Future<String?> getPlatformVersion() {
    return HelloPlatform.instance.getPlatformVersion();
  }

  Future<bool?> checkNetworkConnectionStatus() async {
    return HelloPlatform.instance.checkNetworkConnectionStatus();
  }
}
