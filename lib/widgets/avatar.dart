import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ContactProfile.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    this.radius,
    @required this.profile,
  }) : super(key: key);

  final double radius;
  final ContactProfile profile;

  _buildLetterAvater(BuildContext context, String letter) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).accentColor,
      radius: radius,
      child: CircleAvatar(
        radius: radius - 1,
        child: Text(
          letter,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      return CircleAvatar(
        radius: radius,
        backgroundImage: profile.image?.isNotEmpty == true
            ? AssetImage(profile.image)
            : MemoryImage(profile.thumbnail.bytes),
      );
    } catch (e) {
      if (profile.fullName != null && profile.fullName.isNotEmpty)
        return _buildLetterAvater(context, profile.fullName[0]);

      return _buildLetterAvater(context, 'K');

      // return CircleAvatar(
      //   radius: radius,
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      // );
    }
  }
}
