import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';

import '../../../constants.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: krRounded,
              child: Image.asset(message.media),
            ),
            Container(
              width: 50,
              height: 50,
              child: Icon(
                Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
