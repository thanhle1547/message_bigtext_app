part of 'bloc.dart';

abstract class PinChatEvent extends Equatable {
  const PinChatEvent();

  @override
  List<Object> get props => [];
}

class LoadPinnedChatsEvent extends PinChatEvent {}

class PinAChatEvent extends PinChatEvent {
  final String address;
  final int threadId;

  PinAChatEvent({this.address, this.threadId});

  @override
  List<Object> get props => [address, threadId];
}

class PinChatsEvent extends PinChatEvent {
  final List<String> address;

  PinChatsEvent({this.address});

  @override
  List<Object> get props => [address];
}

class UnPinAChatEvent extends PinChatEvent {
  final String address;
  final int threadId;

  UnPinAChatEvent({this.address, this.threadId});

  @override
  List<Object> get props => [address, threadId];
}

class UnPinChatsEvent extends PinChatEvent {
  final List<String> address;

  UnPinChatsEvent({this.address});

  @override
  List<Object> get props => [address];
}
