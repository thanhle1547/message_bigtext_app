import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/blocs/message/bloc.dart';
import 'package:message_bigtext_app/blocs/message/event.dart';
import 'package:message_bigtext_app/blocs/message/state.dart';
import 'package:message_bigtext_app/constants.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:message_bigtext_app/widgets/chat_input_field.dart';
import 'package:sms/sms.dart';

import 'message.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ScrollController _listScrollController = ScrollController();

  // int _limit = 5;
  // final int _limitIncrement = 5;

  _scrollListener() {
    final currentScroll = _listScrollController.position.pixels;
    final maxScroll = _listScrollController.position.maxScrollExtent;
    // print('''
    //     offset: ${_listScrollController.offset},
    //     currentScroll: $currentScroll,
    //     maxScroll / maxScrollExtent: ${_listScrollController.position.maxScrollExtent},
    //     outOfRange: ${_listScrollController.position.outOfRange},
    //     extentAfter: ${_listScrollController.position.extentAfter};
    //     extentBefore: ${_listScrollController.position.extentBefore};
    // ''');

    // if (_listScrollController.offset >= maxScroll &&
    //     !_listScrollController.position.outOfRange)
    //   setState(() {
    //     _limit += _limitIncrement;
    //   });

    if (maxScroll == currentScroll)
      BlocProvider.of<MessageBloc>(context)
          .add(PreviousMessagesRequestedEvent());
  }

  _onSendCallback() {
    // _listScrollController.animateTo(
    //   // _listScrollController.position.maxScrollExtent,
    //   0,
    //   duration: Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  ListView _buildChatMessageList(List<Widget> widgets) {
    return ListView.builder(
      controller: _listScrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: kpMsgVertical / 1.2),
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _listScrollController.addListener(_scrollListener);

      // case: 1 message + CircularProgressIndicator --> no scrolling
      if (BlocProvider.of<MessageBloc>(context).state
              is MessagesLoadSuccessState ||
          _listScrollController.position.extentAfter == 0 ||
          _listScrollController.position.extentBefore == 0)
        BlocProvider.of<MessageBloc>(context)
            .add(PreviousMessagesRequestedEvent());
    });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (_listScrollController.hasClients) _onSendCallback();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final Chat chat = BlocProvider.of<MessageBloc>(context).chat;

    return Column(
      children: [
        Expanded(
          child: BlocConsumer<MessageBloc, MessageState>(
            listener: (_, state) {
              if (state is MessageSendingState) {
                /* if (state.state == SmsMessageState.Sending)
                  _listScrollController.animateTo(
                    _listScrollController.position.minScrollExtent,
                    // 0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut, // fastOutSlowIn
                  );
                else */
                if (state.state == SmsMessageState.Fail)
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Không gửi được!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    duration: const Duration(seconds: 1),
                    backgroundColor: kcPrimaryColor,
                  ));
              }
            },
            buildWhen: (_, newState) {
              return !(newState is MessageSendingState);
            },
            builder: (context, state) {
              if (state is ErrorState) {
                return Center(
                  child: Text(
                    "Da co loi xay ra: ${state.toString()}",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Theme.of(context).accentColor),
                  ),
                );
              }

              if (state is MessagesInitialState) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is MessagesInitSuccessState) {
                // print('MessagesInitSuccessState');
                return _buildChatMessageList([
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  if (chat != null) Message(message: chat.toChatMessage())
                ]);
              }

              if (state is MessagesLoadSuccessState) {
                print('MessagesLoadSuccessState');
                return _buildChatMessageList([
                  for (var m in state.messages) Message(message: m),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ]);
              }

              if (state is LastMessagesLoadSuccessState) {
                print('LastMessagesLoadSuccessState');
                return _buildChatMessageList([
                  for (var m in state.messages) Message(message: m),
                ]);
              }

              return Center(
                child: Text(
                  'Khong co tin nhan',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              );
            },
          ),
        ),
        ChatInputField(
          sendCallback: _onSendCallback,
        )
      ],
    );
  }

  @override
  void dispose() {
    _listScrollController.removeListener(_scrollListener);
    _listScrollController.dispose();
    super.dispose();
  }
}
