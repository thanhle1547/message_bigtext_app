part of 'bloc.dart';

class PinChatState extends Equatable {
  final Map<int, ContactProfile> profiles;

  PinChatState({this.profiles});

  @override
  List<Object> get props => [profiles];

  // const PinChatState();

  // @override
  // List<Object> get props => [];
}

class PinChatInitial extends PinChatState {
  PinChatInitial() : super(profiles: {});
}

class PinChatStateChanged extends PinChatState {
  PinChatStateChanged() : super(profiles: {});
}

class PinnedChatLoadSuccess extends PinChatState {
  PinnedChatLoadSuccess({Map<int, ContactProfile> profiles})
      : super(profiles: profiles);
}

// class PinAChatSuccess extends PinChatState {
//   PinAChatSuccess({Map<int, ContactProfile> profiles})
//       : super(profiles: profiles);

// final int threadId;
// final ContactProfile profile;

// PinAChatSuccess({this.threadId, this.profile});

// @override
// List<Object> get props => [threadId, profile];
// }
