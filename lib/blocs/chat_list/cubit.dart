import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/blocs/chat_list/state.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/repos/chat_repo.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepo repo;
  List<Chat> _snapshot;

  ChatListCubit({@required this.repo}) : super(const ChatListState.loading()) {
    repo.onSmsReceived.listen((event) {
      int index = _snapshot.indexWhere((el) => el.threadId == event.threadId);
      _snapshot.removeAt(index);
      _snapshot.insert(index, event);

      print(event.toString());

      emit(ChatListState.success(_snapshot));
    });
  }

  getAll() async {
    emit(const ChatListState.loading());
    try {
      _snapshot = await repo.getAll();
      emit(ChatListState.success(_snapshot));
    } on Exception {
      emit(const ChatListState.failure());
    }
  }

  filter(String pattern) {
    pattern = pattern.toLowerCase();

    emit(const ChatListState.loading());
    emit(ChatListState.success(_snapshot
        .where((element) =>
            element.profile.address.toLowerCase().contains(pattern))
        .toList()));
  }

  reset() {
    emit(ChatListState.success(_snapshot));
  }

  // https://github.com/felangel/bloc/blob/master/examples/flutter_complex_list/lib/list/cubit/list_cubit.dart
}
