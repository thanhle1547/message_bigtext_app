import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:message_bigtext_app/blocs/chat_list/cubit.dart';
import 'package:message_bigtext_app/blocs/chat_list/state.dart';
import 'package:message_bigtext_app/blocs/message/bloc.dart';
import 'package:message_bigtext_app/blocs/message/event.dart';
import 'package:message_bigtext_app/blocs/pin_chat/bloc.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/repos/message_repo.dart';
import 'package:message_bigtext_app/repos/snippets_repo.dart';
import 'package:message_bigtext_app/screens/chats/components/search.dart';
import 'package:message_bigtext_app/widgets/avatar.dart';
import 'package:message_bigtext_app/screens/messages/message_screen.dart';

import '../../../constants.dart';
import 'chat_item.dart';
import 'multi_select_item.dart';

class Body extends StatelessWidget {
  final MessageBloc _messageBloc = MessageBloc(repo: MessageRepo());
  final SlidableController _slidableController = SlidableController();
  final FocusNode _searchFocusNode = FocusNode();

  final MultiSelectController multiSelectController;
  final VoidCallback exitMultiSelectModeCallback;
  final Function(int index) onItemSelectCallback;

  Body({
    Key key,
    this.multiSelectController,
    this.exitMultiSelectModeCallback,
    this.onItemSelectCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatListCubit _chatListCubit =
        BlocProvider.of<ChatListCubit>(context);

    return Container(
      child: Column(
        children: [
          Visibility(
            visible: multiSelectController.isSelecting == false,
            child: Search(
              onChanged: (String value) {
                if (value.trim().length == 0)
                  _chatListCubit.reset();
                else
                  _chatListCubit.filter(value.trim());
              },
              clearCallback: () {
                _chatListCubit.reset();
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildPinnedChatContainer(),
                SizedBox(height: 16),
                _buildChatListWidget(),
              ],
            ),
          ),
          Visibility(
            visible: multiSelectController.isSelecting &&
                multiSelectController.listLength != 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                borderRadius: kr30,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Theme.of(context).primaryColor),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => kcBlack8),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(kpMsgVertical)),
                      ),
                      icon: Icon(
                        Icons.push_pin,
                        size: 26,
                      ),
                      label: Text(
                        'Ghim',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  VerticalDivider(
                    indent: 16,
                    endIndent: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Theme.of(context).primaryColor),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => kcBlack8),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(kpMsgVertical)),
                      ),
                      icon: Icon(
                        Icons.delete,
                        size: 26,
                      ),
                      label: Text(
                        'Xóa',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BlocBuilder<PinChatBloc, PinChatState> _buildPinnedChatContainer() {
    return BlocBuilder<PinChatBloc, PinChatState>(
      // buildWhen: (previousState, newState) {
      //   print('1: ------------------------------');
      //   print(previousState.profiles.toString());
      //   print(newState.profiles.toString());
      //   print('--------------------------------');

      //   return previousState.profiles.length != newState.profiles.length;
      // },
      builder: (context, state) {
        print(
            "_buildPinnedChatContainer: ${state.profiles.length} ${state.toString()}");

        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutExpo,
          height: multiSelectController.isSelecting == false &&
                  state.profiles.length != 0
              ? null
              : 0,
          decoration: BoxDecoration(
            color: kcWhite14, // or 16 or Colors.white12,
            borderRadius: kr15,
          ),
          child: Column(
            children: [
              SizedBox(height: 6),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kpDefaultPadding / 4),
                child: Text(
                  "Liên hệ đã ghim",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                ),
              ),
              _buildContactListWidget(),
              SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  Container _buildContactListWidget() {
    return Container(
      width: double.infinity,
      height: 140,
      child: Center(
        child: BlocBuilder<PinChatBloc, PinChatState>(
          // buildWhen: (previousState, newState) {
          //   print('2: -----------------------------');
          //   print(previousState.profiles.toString());
          //   print(newState.profiles.toString());
          //   print('--------------------------------');

          //   return previousState.profiles.length != newState.profiles.length;
          // },
          // => previousState.profiles.length != newState.profiles.length,
          builder: (context, state) => ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap:
                state.profiles.length < 3, // true -> cannot scroll to the right
            itemCount: state.profiles.length /* ?? chatsData.length */,
            itemBuilder: (context, index) {
              int key = state.profiles?.keys?.elementAt(index);

              // print(state.profiles[index].toString());

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kpMsgHorizontal / 2,
                    vertical: kpItemVertical / 2),
                child: InkWell(
                  onTap: () {
                    Chat chat = Chat(
                      profile: state.profiles.values.elementAt(index),
                      threadId: key,
                    );

                    _messageBloc.add(MessagesInitEvent(chat: chat));

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BlocProvider(
                        create: (context) => _messageBloc,
                        child: RepositoryProvider(
                          create: (_) => SnippetRepo(),
                          child: MessageScreen(),
                        ),
                      );
                    }));
                  },
                  onLongPress: () {},
                  customBorder: RoundedRectangleBorder(
                    borderRadius: kr10,
                  ),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kpMsgHorizontal / 2,
                      vertical: kpItemVertical / 2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Avatar(
                          radius: 36,
                          profile: state.profiles.values.elementAt(index)
                          /* ?? chatsData[index].profile */,
                        ),
                        SizedBox(height: 16),
                        Text(
                          state.profiles.values.elementAt(index)?.fullName ??
                              state.profiles.values.elementAt(index)?.address
                          /* ?? chatsData[index].profile.fullName */,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Theme.of(context).accentColor),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  BlocBuilder _buildChatListWidget() {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        switch (state.status) {
          case ListStatus.Success:
            multiSelectController.set(state.items.length);

            return Column(
              children: state.items
                  .asMap()
                  .entries
                  .map((entry) {
                    final idx = entry.key;
                    final chat = entry.value;
                    return ChatItem(
                      index: idx,
                      chat: chat,
                      slidableController: _slidableController,
                      multiSelectController: multiSelectController,
                      tabCallback: () {
                        if (_searchFocusNode.hasPrimaryFocus) return;

                        _messageBloc.add(MessagesInitEvent(chat: chat));

                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return BlocProvider.value(
                              value: _messageBloc,
                              child: RepositoryProvider(
                                create: (_) => SnippetRepo(),
                                child: MessageScreen(),
                              ),
                            );
                          },
                        ));
                      },
                      multiSelectModeCallback: () => onItemSelectCallback(idx),
                    );
                  })
                  .expand((element) => [
                        element,
                        Divider(
                          indent: kpItemHorizontal * 4 + 34,
                          endIndent: kpItemHorizontal,
                          color: Theme.of(context).accentColor,
                        )
                      ])
                  .toList(),
            );
          case ListStatus.Failure:
            return Expanded(
                child: Column(
              children: [
                Center(child: Text('Oops something went wrong!')),
              ],
            ));
          default:
            return Padding(
              padding: EdgeInsets.only(top: 100),
              child: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
