import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:sms/sms.dart';

@immutable
abstract class MessageEvent extends Equatable {
  const MessageEvent([List prop = const []]) : super();

  @override
  List<Object> get props => [];
}

class MessagesInitEvent extends MessageEvent {
  final Chat chat;

  MessagesInitEvent({@required this.chat}) : super([chat]);

  @override
  List<Object> get props => [chat];
}

class MessagesLoadingEvent extends MessageEvent {}

class MessagesRequestedEvent extends MessageEvent {}

class PreviousMessagesRequestedEvent extends MessageEvent {}

class RequestSendTextMessageEvent extends MessageEvent {
  final String message;

  RequestSendTextMessageEvent(this.message) : super([message]);

  @override
  List<Object> get props => [message];
}

class SendTextMessageEvent extends MessageEvent {
  final String address;
  final String message;
  final int threadId;

  SendTextMessageEvent(this.address, this.message, this.threadId)
      : super([address, message, threadId]);

  @override
  List<Object> get props => [address, message, threadId];
}

class SendingStateChangedEvent extends MessageEvent {
  final ChatMessage message;
  final SmsMessageState sendingState;

  SendingStateChangedEvent(this.message, this.sendingState)
      : super([message, sendingState]);

  @override
  List<Object> get props => [message, sendingState];
}

// class TextMessageDeliveredEvent extends MessageEvent {
//   final SmsMessage sms;

//   TextMessageDeliveredEvent(this.sms) : super([sms]);

//   @override
//   List<Object> get props => [sms];
// }
