import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:message_bigtext_app/screens/messages/components/audio_message.dart';
import 'package:message_bigtext_app/screens/messages/components/text_message.dart';
import 'package:message_bigtext_app/screens/messages/components/video_message.dart';

import '../../../constants.dart';

class Message extends StatelessWidget {
  const Message({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;

  Widget resolveMessage(BuildContext context, ChatMessage message) {
    switch (message.type) {
      case ChatMessageType.Text:
        return TextMessage(message: message);
      case ChatMessageType.Audio:
        return AudioMessage(message: message);
      case ChatMessageType.Video:
        return VideoMessage(message: message);
      default:
        return Container(
          decoration: BoxDecoration(color: Theme.of(context).accentColor),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
      padding: message.isSender() ? kpMsgSender : kmMsgReceiver,
      child: Row(
        mainAxisAlignment: message.isSender()
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [Flexible(child: resolveMessage(context, message))],
      ),
    );
  }
}
