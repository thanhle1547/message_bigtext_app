import 'package:flutter/material.dart';

class CheckCircleAvatar extends StatelessWidget {
  const CheckCircleAvatar({
    Key key,
    this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      radius: radius,
      child: CircleAvatar(radius: radius - 1, child: Icon(Icons.check)),
    );
  }
}
