import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ChatMessage.dart';
import 'package:message_bigtext_app/utils/time_util.dart';
import 'package:sms/sms.dart';

import '../../../constants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kpMsg,
      decoration: BoxDecoration(
        color: message.isSender() ? kcSender : kcReceiver,
        borderRadius: message.isSender() ? krSender : krReceiver,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w400, height: 1.5),
          ),
          SizedBox(height: 10),
          if (message.state == SmsMessageState.Sending) ...[
            Text(
              'Đang gửi...',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kpDefaultPadding * 2),
              child: LinearProgressIndicator(),
            ),
          ] else if (message.state == SmsMessageState.Fail)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kpDefaultPadding),
              child: Text(
                'Không gửi được',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            )
          else if (message.time != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kpDefaultPadding),
              child: Text(
                TimeUtil.getDateTimeRepresentation(message.time),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
        ],
      ),
    );
  }
}
