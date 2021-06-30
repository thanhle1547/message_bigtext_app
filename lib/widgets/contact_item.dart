import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ContactProfile.dart';

import '../constants.dart';
import 'avatar.dart';

class ContactItem extends StatelessWidget {
  final ContactProfile profile;

  final GestureTapDownCallback tabDownCallback;
  final GestureTapCallback tabCallback;

  const ContactItem({
    Key key,
    this.profile,
    this.tabDownCallback,
    @required this.tabCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kpMsgVertical / 2),
      child: InkWell(
        onTapDown: tabDownCallback,
        onTap: tabCallback,
        customBorder: RoundedRectangleBorder(
          borderRadius: kr10,
        ),
        child: Ink(
          padding: const EdgeInsets.symmetric(
              horizontal: kpItemHorizontal, vertical: kpItemVertical),
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              Avatar(radius: 26, profile: profile),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kpItemHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName ?? 'Khong ten',
                          style: kfTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: koContent,
                        child: Text(
                          profile.address ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
