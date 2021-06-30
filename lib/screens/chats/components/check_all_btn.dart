import 'package:flutter/material.dart';

import '../../../constants.dart';

class CheckAllBtn extends StatefulWidget {
  CheckAllBtn({Key key, this.onCheckCallback, this.onUnCheckCallback})
      : super(key: key);

  final VoidCallback onCheckCallback;
  final VoidCallback onUnCheckCallback;

  @override
  _CheckAllBtnState createState() => _CheckAllBtnState();
}

class _CheckAllBtnState extends State<CheckAllBtn> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Color(0x26FFFFFF)),
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.all(kpMsgVertical)),
      ),
      onPressed: () {
        setState(() {
          isChecked = !isChecked;
          isChecked ? widget.onCheckCallback() : widget.onUnCheckCallback();
        });
      },
      icon: Icon(
        isChecked ? Icons.select_all : Icons.done_all,
        size: 30,
      ),
      label: Text(
        isChecked ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Theme.of(context).accentColor),
      ),
    );
  }
}
