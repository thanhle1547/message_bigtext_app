import 'package:message_bigtext_app/utils/services/local_storage_service.dart';

class PinChatProvider {
  Future<List<String>> load() => Preferences.getPinnedPhoneNumber();

  Future<void> write(List<String> data) =>
      Preferences.setPinnedPhoneNumber(data);
}
