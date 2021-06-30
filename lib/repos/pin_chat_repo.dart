import 'package:message_bigtext_app/providers/pin_chat_provider.dart';

class PinChatRepo {
  final PinChatProvider _provider;

  PinChatRepo() : _provider = PinChatProvider();

  Future<Map<int, String>> get() =>
      _provider.load().then((result) => Map.fromIterable(
            result,
            key: (e) => int.tryParse(e.split(':')[0]),
            value: (e) => e.split(':')[1],
          ));

  Future<void> set(Map<int, String> mapData) => _provider
      .write(mapData.entries.map((e) => "${e.value}:${e.key}").toList());
}
