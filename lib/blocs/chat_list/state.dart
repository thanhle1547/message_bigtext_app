import 'package:equatable/equatable.dart';
import 'package:message_bigtext_app/models/Chat.dart';

enum ListStatus { Loading, Success, Failure }

class ChatListState extends Equatable {
  final ListStatus status;
  final List<Chat> items;

  const ChatListState._({
    this.status = ListStatus.Loading,
    this.items = const [],
  });

  const ChatListState.loading() : this._();

  const ChatListState.success(List<Chat> items)
      : this._(status: ListStatus.Success, items: items);

  const ChatListState.failure() : this._(status: ListStatus.Failure);

  @override
  List<Object> get props => [status, items];
}
