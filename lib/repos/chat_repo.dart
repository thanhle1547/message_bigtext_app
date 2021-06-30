import 'dart:async';

import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/providers/chat_provider.dart';
import 'package:sms/sms.dart';

/// Serves as an abstraction between the client code and the data provider.
/// You don't have to know where the data is coming from.
/// It may come from API provider or Local database.
class ChatRepo {
  ChatProvider _provider = ChatProvider();

  Stream<Chat> get onSmsReceived => _provider.onSmsReceived.transform<Chat>(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) => sink.add(Chat.fromSmsMessage(data)),
          handleDone: (sink) => sink.close(),
          handleError: (error, stacktrace, sink) =>
              sink.addError('Something went wrong: $error'),
        ),
      );

  Future<List<Chat>> getAll() async {
    return await Chat.fromSms(_provider.getAll)
        .then((value) => value.length != 0 ? value : chatsData)
        .then((value) {
      value.sort((chat1, chat2) => -chat1.time.compareTo(chat2.time));
      return value;
    }).catchError((e) => chatsData);
  }

  remove(int id) => _provider.remove(id);
}
