import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:sms/sms.dart';

import 'ContactProfile.dart';

class Chat extends Equatable {
  final int id;
  final int threadId;
  final ContactProfile profile;
  final String message, image;
  final SmsMessageKind kind;
  final SmsMessageState state;
  final DateTime time;
  final bool isRead;

  Chat({
    this.id,
    this.threadId,
    this.profile,
    this.kind,
    this.state,
    this.message,
    this.image,
    this.time,
    this.isRead,
  });

  static Future<List<Chat>> fromSms(Future<List<SmsThread>> sms) {
    return sms.then((value) => value.map((e) {
          final lastMsg = e.messages.last;
          return Chat(
            threadId: e.threadId,
            profile: ContactProfile(
              fullName: lastMsg.address,
              address: lastMsg.sender,
              thumbnail: e.contact.thumbnail,
            ),
            message: lastMsg.body,
            kind: lastMsg.kind,
            state: lastMsg.state,
            time: lastMsg.dateSent,
            isRead: lastMsg.isRead,
          );
        }).toList());
  }

  static Chat fromSmsMessage(SmsMessage sms) {
    return Chat(
      id: sms.id,
      threadId: sms.threadId,
      profile: ContactProfile(fullName: sms.sender, address: sms.address),
      kind: sms.kind,
      state: sms.state,
      message: sms.body,
      time: sms.date,
      isRead: sms.isRead,
    );
  }

  ChatMessage toChatMessage() => ChatMessage(
        text: message,
        type: ChatMessageType.Text,
        state: SmsMessageState.Sent,
        kind: kind,
        time: time,
      );

  @override
  String toString() {
    return "id: $id, threadId: $threadId, name: ${profile.fullName}, address: ${profile.address} message: $message, kind: $kind, state: $state, time: $time, isRead: $isRead";
  }

  @override
  List<Object> get props => [id, threadId, message, state, time];
}

final now = DateTime.now();

List<Chat> chatsData = [
  Chat(
    profile: ContactProfile(
      fullName: "Jenny Wilson",
      image: "assets/images/user.png",
    ),
    message: "Hope you are doing well...",
    kind: SmsMessageKind.Sent,
    state: SmsMessageState.Delivered,
    time: now.subtract(Duration(minutes: 3)), // 3m ago
    isRead: false,
  ),
  Chat(
    profile: ContactProfile(
      fullName: "Esther Howard",
      image: "assets/images/user_2.png",
    ),
    message: "Hello Abdullah! I am...",
    kind: SmsMessageKind.Received,
    time: now.subtract(Duration(minutes: 8)), // 8m ago,
    isRead: true,
  ),
  Chat(
    profile: ContactProfile(
      fullName: "Ralph Edwards",
      image: "assets/images/user_3.png",
    ),
    message: "Do you have update...",
    kind: SmsMessageKind.Received,
    time: now.subtract(Duration(days: 5)), // 5d ago,
    isRead: false,
  ),
  Chat(
    profile: ContactProfile(
      fullName: "Jacob Jones",
      image: "assets/images/user_4.png",
    ),
    message: "You’re welcome :)",
    kind: SmsMessageKind.Sent,
    state: SmsMessageState.Delivered,
    time: now.subtract(Duration(days: 5)), // 5d ago,
    isRead: true,
  ),
  Chat(
    profile: ContactProfile(
      fullName: "Albert Flores",
      image: "assets/images/user_5.png",
    ),
    message: "Thanks",
    kind: SmsMessageKind.Sent,
    state: SmsMessageState.Delivered,
    time: now.subtract(Duration(days: 6)), // 6d ago,
    isRead: false,
  ),
];
