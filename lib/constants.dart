import 'package:flutter/material.dart';

const kcBlack8 = Color(0x14000000);
const kcWhite14 = Color(0x24FFFFFF);
const kcWhite16 = Color(0x29FFFFFF);

// const kcPrimaryColor = Color(0xFF00BF6D);
// const kcPrimaryColor = Color(0xFFFFE605);
// const kcPrimaryColor = Color(0xFFFCD329);
// const kcPrimaryColor = Color(0xFFF7E90A);
// const kcPrimaryColor = Color(0xFFC4F502);
// const kcPrimaryColor = Color(0xFFCEC26C);
const kcPrimaryColor = Color(0xFFCEC250);
const kcSecondaryColor = Color(0xFFFE9901);
const kcContentColorLightTheme = Color(0xFF1D1D35);
const kcContentColorDarkTheme = Color(0xFFF5FCF9);
const kcWarninngColor = Color(0xFFF3BB1C);
const kcErrorColor = Color(0xFFF03738);
const kcSender = Colors.white; // Color(0xFFEDEDED);
// const kcReceiver =
//     Color(0xF0FFFFFF); // 94 or Colors.white70; // Color(0xFFEDEDED);
const kcReceiver = Color(0xEDFFFFFF); // 93

// const kcReceiver = Color(0xFFF0F2F5);
// const kcReceiver = Color(0xFFF5F9FF);

const ktsWhite = TextStyle(color: Colors.white);

const kmDefaultMargin = 20.0;

const kpDefaultPadding = 20.0;
const kpItemHorizontal = kpDefaultPadding;
const kpItemVertical = kpDefaultPadding * 0.75;
const kpMsgHorizontal = kpDefaultPadding * 0.75;
const kpMsgVertical = kpDefaultPadding / 2;
const kpMsg = EdgeInsets.symmetric(
    horizontal: kpMsgHorizontal, vertical: kpMsgVertical * 1.25);
const kmMsg = EdgeInsetsDirectional.only(top: kpDefaultPadding);
const kpMsgSender = EdgeInsets.only(
  top: kpDefaultPadding / 2,
  bottom: kpDefaultPadding / 2,
  left: kpMsgHorizontal * 3,
);
const kmMsgReceiver = EdgeInsets.only(
  top: kpDefaultPadding / 2,
  bottom: kpDefaultPadding / 2,
  right: kpMsgHorizontal * 3,
);

const kfTitle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
const koContent = 0.84;

final krRounded = BorderRadius.circular(40);
final kr30 = BorderRadius.circular(30);
final kr20 = BorderRadius.circular(20);
final kr15 = BorderRadius.circular(15);
final kr10 = BorderRadius.circular(10);

final krTop20 = BorderRadius.only(
    topLeft: Radius.circular(20), topRight: Radius.circular(20));
final krTop30 = BorderRadius.only(
    topLeft: Radius.circular(30), topRight: Radius.circular(30));

final krSender = BorderRadius.only(
  topLeft: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);
// final krSenderSending = BorderRadius.only(
//   topLeft: Radius.circular(20),
// );
final krReceiver = BorderRadius.only(
  topRight: Radius.circular(20),
  bottomLeft: Radius.circular(20),
  bottomRight: Radius.circular(20),
);

final ksdList = BoxShadow(
  offset: Offset(0, -30),
  blurRadius: 32,
  spreadRadius: 20,
  color: Color(0xFF087949).withOpacity(0.08),
);

const Duration kUnconfirmedSplashDuration = const Duration(seconds: 3);
const Duration kSplashFadeDuration = const Duration(seconds: 2);

const double kSplashInitialSize = 0.0; // logical pixels
const double kSplashConfirmedVelocity = 0.6;
