import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:message_bigtext_app/repos/message_repo.dart';
import 'package:sms/sms.dart';

import 'event.dart';
import 'state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepo repo;
  Chat chat;
  List<ChatMessage> _snapshot = [];

  int _start = 0;
  final int _count = 10;
  bool _isLastMsgLoaded = false;

  MessageBloc({@required this.repo}) : super(MessagesInitialState());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is MessagesInitEvent) {
      yield MessagesInitialState();
      this.chat = event.chat;
      _snapshot.clear();
      _start = 0;
      _isLastMsgLoaded = false;

      // print('BLoC: ' + chat.toString());

      yield MessagesInitSuccessState();
      yield* _reload();
    } else if (event is RequestSendTextMessageEvent) {
      yield MessageSendingState(state: SmsMessageState.Sending);

      SmsMessage result = await repo.create(
          _snapshot[0].id, chat.profile.address, event.message, chat.threadId);
      ChatMessage resolve = ChatMessage.fromSms(result);

      result.onStateChanged.listen((event) {
        print("body: '${result.body}' state: ${event.toString()}");

        add(SendingStateChangedEvent(resolve, event));
      });
    } else if (event is SendingStateChangedEvent) {
      yield* _mapSendEventToState(event.message, event.sendingState);
    } else if (event is PreviousMessagesRequestedEvent) {
      _start += _count;
      yield* _reload();
    } else if (event is MessagesRequestedEvent) {}
  }

  Stream<MessageState> _reload() async* {
    try {
      if (_isLastMsgLoaded == true) return;

      List<ChatMessage> messages =
          await repo.getAll(chat.threadId, _start, _count);
      _snapshot.addAll(messages);

      if (messages.length != 0) {
        yield MessagesLoadSuccessState(messages: _snapshot);
      } else {
        _isLastMsgLoaded = true;
        yield LastMessagesLoadSuccessState(messages: _snapshot);
      }
    } catch (e) {
      yield ErrorState(e);
    }
  }

  Stream<MessageState> _mapSendEventToState(
      ChatMessage message, SmsMessageState msgState) async* {
    yield MessageSendingState(state: msgState);

    int index = _snapshot.indexWhere((element) => element.id == message.id);
    ChatMessage msg;

    if (index == -1) {
      msg = message.copyWith(state: msgState);
      index = 0;
    } else {
      msg = _snapshot[index].copyWith(state: msgState);
      _snapshot.removeAt(index);
    }

    print("_mapSendEventToState: ${msg.toString()}");

    _snapshot.insert(index, msg);
    yield MessagesLoadSuccessState(messages: _snapshot);
  }
}
