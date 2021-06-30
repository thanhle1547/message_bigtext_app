import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';

import '../../../constants.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      height: 34,
      padding: kpMsg,
      decoration: BoxDecoration(
        color: message.isSender() ? kcSender : kcReceiver,
        borderRadius: krRounded,
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          Slider(value: 0, onChanged: (val) {}),
          Text('0.37'),
        ],
      ),
    );
  }
}
