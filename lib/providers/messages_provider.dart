import 'package:sms/sms.dart';

/// he lowest layer in our application architecture (the data provider).
/// Its only responsibility is to fetch data directly from our API.
class MessagesProvider {
  final SmsQuery _query;
  final SmsSender _sender;
  final SmsReceiver _receiver;

  MessagesProvider()
      : _query = SmsQuery(),
        _sender = SmsSender(),
        _receiver = SmsReceiver();

  Stream<SmsMessage> get onSmsReceived => _receiver.onSmsReceived;

  Future<List<SmsMessage>> getAll(int threadId, int start, int count) =>
      _query.querySms(
          start: start,
          count: count,
          threadId: threadId,
          kinds: [SmsQueryKind.Inbox, SmsQueryKind.Sent]);

  Future<SmsMessage> create(SmsMessage msg) async => _sender.sendSms(msg);

  Future<void> delete(int id) async {}
}
