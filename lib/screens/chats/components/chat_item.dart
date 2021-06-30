import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:message_bigtext_app/blocs/pin_chat/bloc.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/screens/chats/components/check_circle_avatar.dart';
import 'package:message_bigtext_app/widgets/avatar.dart';
import 'package:message_bigtext_app/utils/time_util.dart';

import '../../../constants.dart';
import 'multi_select_item.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(
      {Key key,
      @required this.index,
      @required this.chat,
      @required this.tabCallback,
      @required this.multiSelectModeCallback,
      @required this.slidableController,
      @required this.multiSelectController})
      : super(key: key);

  final int index;
  final Chat chat;
  final GestureTapCallback tabCallback;
  final VoidCallback multiSelectModeCallback;
  final SlidableController slidableController;
  final MultiSelectController multiSelectController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kpMsgVertical / 2),
      child: Slidable(
        actionPane: SlidableBehindActionPane(),
        actionExtentRatio: 0.25,
        actions: [
          BlocBuilder<PinChatBloc, PinChatState>(
            // listener: (context, state) {
            //   final isPinned = state.profiles.values
            //       .any((el) => el.address == chat.profile.address);
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text(
            //       "${isPinned ? 'Unpinned' : 'Pinned'} ${chat.profile.fullName}",
            //       style: Theme.of(context)
            //           .textTheme
            //           .headline6
            //           .copyWith(color: Theme.of(context).accentColor),
            //     ),
            //     duration: const Duration(seconds: 1),
            //     backgroundColor: kcPrimaryColor,
            //   ));
            // },
            builder: (context, state) {
              final isPinned = state.profiles.values
                  .any((el) => el.address == chat.profile.address);

              return IconSlideAction(
                icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                caption: isPinned ? 'Đã ghim' : 'Ghim',
                foregroundColor: Theme.of(context).accentColor,
                color: Colors.blueGrey,
                closeOnTap: true,
                onTap: () {
                  BlocProvider.of<PinChatBloc>(context).add(isPinned
                      ? UnPinAChatEvent(
                          address: chat.profile.address,
                          threadId: chat.threadId,
                        )
                      : PinAChatEvent(
                          address: chat.profile.address,
                          threadId: chat.threadId,
                        ));
                },
              );
            },
          ),
        ],
        secondaryActions: [
          IconSlideAction(
            icon: Icons.delete,
            caption: 'Xoa',
            foregroundColor: Theme.of(context).accentColor,
            color: Colors.red,
            onTap: () {},
          )
        ],
        controller: slidableController,
        enabled: multiSelectController.isSelecting == false,
        // child: InkWell(
        // onTap: () {
        //   if (multiSelectController.isSelecting) return;

        //   tabCallback();
        // },
        child: MultiSelectItem(
          isSelecting: multiSelectController.isSelecting,
          onSelected: multiSelectModeCallback,
          onTap: tabCallback,
          customBorder: RoundedRectangleBorder(
            borderRadius: kr10,
          ),
          child: Ink(
            padding: const EdgeInsets.symmetric(
                horizontal: kpItemHorizontal, vertical: kpItemVertical),
            color: multiSelectController.isSelected(index) == false
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor.withOpacity(0.2),
            child: Row(
              children: [
                multiSelectController.isSelected(index) == false
                    ? Avatar(radius: 34, profile: chat.profile)
                    : CheckCircleAvatar(radius: 34),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: kpItemHorizontal, right: kpItemHorizontal / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat.profile.fullName ?? '',
                            // style: kfTitle.copyWith(
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                        SizedBox(height: 8),
                        Opacity(
                          opacity: koContent,
                          child: Text(
                            chat.message ?? '',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 4),
                        Opacity(
                          opacity: koContent,
                          child: Text(
                            '‒ ' +
                                TimeUtil.getDateTimeRepresentation(
                                    chat.time ?? ''),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        if (!chat.isRead)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: kr15,
                              ),
                              child: Text('1 tin nhắn mới'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Text(
                //   chat.threadId.toString(),
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyText2
                //       .copyWith(color: Colors.white),
                // ),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
