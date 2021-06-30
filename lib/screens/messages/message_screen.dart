import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/blocs/message/bloc.dart';
import 'package:message_bigtext_app/blocs/message/event.dart';
import 'package:message_bigtext_app/blocs/message/state.dart';
import 'package:message_bigtext_app/constants.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/screens/messages/components/body.dart';
import 'package:message_bigtext_app/widgets/avatar.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<MessageBloc, MessageState>(builder: (context, state) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Avatar(
                radius: 24,
                profile: BlocProvider.of<MessageBloc>(context).chat.profile,
              ),
              SizedBox(width: kpMsgVertical),
              Text(
                BlocProvider.of<MessageBloc>(context).chat.profile.fullName,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          actions: [
            IconButton(icon: Icon(Icons.local_phone), onPressed: () {}),
            SizedBox(width: 8.0),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Body(),
        ),
      ),
    );
    // });
  }
}
