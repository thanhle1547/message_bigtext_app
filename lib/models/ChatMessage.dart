import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

enum ChatMessageType { Draft, Text, Audio, Image, Video }

class ChatMessage extends Equatable {
  final int id;
  final String text;
  final ChatMessageType type;
  final SmsMessageKind kind;
  final SmsMessageState state;
  final String media;
  final DateTime time;
  // final int simCardSlot;

  ChatMessage({
    this.id,
    this.text,
    this.type,
    @required this.kind,
    this.state,
    this.media,
    this.time,
    // this.simCardSlot,
  });

  static ChatMessage fromSms(SmsMessage sms) => ChatMessage(
      text: sms.body,
      type: ChatMessageType.Text,
      kind: sms.kind,
      state: sms.state,
      time: sms.date);

  static Future<List<ChatMessage>> fromSmsList(Future<List<SmsMessage>> sms) {
    return sms.then((value) => value
        .map((e) => ChatMessage(
            id: e.id,
            text: e.body,
            type: ChatMessageType.Text,
            kind: e.kind,
            state: e.state,
            time: e.date))
        .toList());
  }

  bool isSender() => kind == SmsMessageKind.Sent;

  @override
  String toString() {
    return "id: $id, text: $text, type: ${type.toString()}, kind: ${kind.toString()}, state: ${state.toString()}, time: ${time.toString()}";
  }

  ChatMessage copyWith({
    String text,
    ChatMessageType type,
    SmsMessageKind kind,
    SmsMessageState state,
    String media,
    DateTime time,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      type: type ?? this.type,
      kind: kind ?? this.kind,
      state: state ?? this.state,
      media: media ?? this.media,
      time: time ?? this.time,
    );
  }

  @override
  List<Object> get props => [id, state, time];
}

List<ChatMessage> demoChatMessages = [
  ChatMessage(
    text: "Hi Sajol,",
    type: ChatMessageType.Text,
    kind: SmsMessageKind.Received,
    state: SmsMessageState.Delivered,
  ),
  ChatMessage(
    text: "Hello, How are you?",
    type: ChatMessageType.Text,
    kind: SmsMessageKind.Sent,
    state: SmsMessageState.Delivered,
  ),
  ChatMessage(
    text: "",
    type: ChatMessageType.Audio,
    kind: SmsMessageKind.Received,
    state: SmsMessageState.Delivered,
  ),
  ChatMessage(
      text: "",
      type: ChatMessageType.Video,
      kind: SmsMessageKind.Sent,
      state: SmsMessageState.Delivered,
      media: "assets/images/Video Place Here.png"),
  ChatMessage(
    text: "Error happend",
    type: ChatMessageType.Text,
    kind: SmsMessageKind.Sent,
    state: SmsMessageState.Fail,
  ),
  ChatMessage(
    text: "This looks great man!!",
    type: ChatMessageType.Text,
    kind: SmsMessageKind.Received,
    state: SmsMessageState.Delivered,
  ),
  ChatMessage(
    text: "Glad you like it",
    type: ChatMessageType.Text,
    kind: SmsMessageKind.Sent,
    state: SmsMessageState.Fail,
  ),
];
