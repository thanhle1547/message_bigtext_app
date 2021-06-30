import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:sms/sms.dart';

@immutable
abstract class MessageState extends Equatable {
  MessageState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class MessagesInitialState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessagesInitSuccessState extends MessageState {
  @override
  List<Object> get props => [];
}

class MessagesLoadInProgressState extends MessageState {
  final List<ChatMessage> messages;

  MessagesLoadInProgressState({@required this.messages}) : super(messages);

  @override
  List<Object> get props => [messages];
}

class MessagesLoadSuccessState extends MessageState {
  final List<ChatMessage> messages;

  MessagesLoadSuccessState({@required this.messages}) : super(messages);

  @override
  List<Object> get props => [messages];
}

class LastMessagesLoadSuccessState extends MessageState {
  final List<ChatMessage> messages;

  LastMessagesLoadSuccessState({@required this.messages}) : super(messages);

  @override
  List<Object> get props => [messages];
}

class MessagesRequestedState extends MessageState {
  @override
  List<Object> get props => [];
  // final List<ChatMessage> messageList;

  // MessagesRequestedState({@required this.messageList}) : super([messageList]);

  // @override
  // List<Object> get props => throw UnimplementedError();
}

// class MessageRequestAreSendingState extends MessageState {
//   @override
//   List<Object> get props => [];
// }

class MessageSendingState extends MessageState {
  final SmsMessageState state;

  MessageSendingState({@required this.state}) : super([state]);

  @override
  List<Object> get props => [state];
}

class ErrorState extends MessageState {
  final Exception exception;

  ErrorState(this.exception) : super([exception]);

  @override
  List<Object> get props => throw UnimplementedError();
}
