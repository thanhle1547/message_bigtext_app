import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:message_bigtext_app/providers/messages_provider.dart';
import 'package:sms/sms.dart';

class MessageRepo {
  MessagesProvider _provider = MessagesProvider();

  Stream<SmsMessage> get onSmsReceived => _provider.onSmsReceived;

  Future<
      List<ChatMessage>> getAll(int threadId, int start, int count) => ChatMessage
          .fromSmsList(_provider.getAll(threadId, start, count))
      /*.then(
        (value) {
          value.sort((chat1, chat2) => -chat1.time.compareTo(chat2.time));
          return value;
        },
      )*/
      .catchError((e) => demoChatMessages);

  Future<SmsMessage> create(
      int id, String address, String body, int threadId) async {
    SmsMessage resolve = SmsMessage(
      address,
      body,
      id: id,
      threadId: threadId,
      kind: SmsMessageKind.Sent,
    );
    // SmsMessage result = await _provider.create(resolve);
    // return ChatMessage.fromSms(result);
    return await _provider.create(resolve);
  }

  Future<void> delete(int id) async {}
}
