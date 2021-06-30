import 'package:sms/sms.dart';

/// he lowest layer in our application architecture (the data provider).
/// Its only responsibility is to fetch data directly from our API.
class ChatProvider {
  final SmsQuery _query;
  final SmsReceiver _receiver;

  ChatProvider()
      : _query = SmsQuery(),
        _receiver = SmsReceiver();

  Stream<SmsMessage> get onSmsReceived => _receiver.onSmsReceived;

  Future<List<SmsThread>> get getAll async => _query.getAllThreads;

  Future<void> remove(int id) async {}
}
