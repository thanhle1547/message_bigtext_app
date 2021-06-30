import 'package:flutter/material.dart';
import 'package:message_bigtext_app/screens/new_message/components/body.dart';

class NewMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tin nhắn mới'),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Body(),
        ),
      ),
    );
  }
}
