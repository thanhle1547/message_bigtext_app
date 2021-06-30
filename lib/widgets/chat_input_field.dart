import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/blocs/font_size_factor/bloc.dart';
import 'package:message_bigtext_app/blocs/message/bloc.dart';
import 'package:message_bigtext_app/blocs/message/event.dart';
import 'package:message_bigtext_app/repos/snippets_repo.dart';

import '../constants.dart';

class ChatInputField extends StatefulWidget {
  ChatInputField({
    Key key,
    this.sendCallback,
  }) : super(key: key);

  final sendCallback;

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  bool _isBtnMorePressed = false;

  final columnCount = 2;

  // String _validator(String val) {
  //   if (val.isNotEmpty && (_focusNode.hasFocus || _focusNode.hasPrimaryFocus))
  //     setState(() {});

  //   return val;
  // }

  @override
  initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_isBtnMorePressed && _focusNode.hasFocus)
        setState(() {
          _isBtnMorePressed = false;
        });
    });
  }

  _sendSms() {
    // print(_textEditingController.text.trim());
    BlocProvider.of<MessageBloc>(context)
        .add(RequestSendTextMessageEvent(_textEditingController.text.trim()));
    _textEditingController.clear();
    _focusNode.unfocus();
    if (widget.sendCallback != null) widget.sendCallback();
  }

  _btnMoreOnPress() {
    setState(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
        _isBtnMorePressed = true;
      } else
        _isBtnMorePressed = !_isBtnMorePressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _snippets = RepositoryProvider.of<SnippetRepo>(context).snippets;
    final itemWidth =
        (MediaQuery.of(context).size.width - (10 * 2 * columnCount)) /
            columnCount;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: double.infinity,
      height: _isBtnMorePressed
          ? 192 * BlocProvider.of<FontSizeBloc>(context).state.size
          : 70 * BlocProvider.of<FontSizeBloc>(context).state.size,
      padding: EdgeInsets.only(top: kpMsgVertical),
      decoration: BoxDecoration(
        // color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [ksdList],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: kpMsgVertical),
                RotationTransition(
                  turns:
                      AlwaysStoppedAnimation(_isBtnMorePressed ? 45 / 360 : 0),
                  child: IconButton(
                      icon: Icon(Icons.add_circle, size: 26),
                      onPressed: _btnMoreOnPress),
                ),
                SizedBox(width: kpMsgVertical),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: kpItemHorizontal),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: krRounded,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 36,
                          spreadRadius: 5,
                          color: Color(0xFFFFFFFF).withOpacity(0.4),
                        ),
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 10,
                          color: Color(0xFF000000),
                        ),
                      ],
                    ),
                    // child: TextFormField(
                    child: TextField(
                      onEditingComplete: () {},
                      // onSubmitted: (value) {
                      //   log(value);
                      //   widget.sendCallback && widget.sendCallback();
                      // },
                      // validator: _validator,
                      focusNode: _focusNode,
                      controller: _textEditingController,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          letterSpacing: 0.85, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: kpMsgVertical),
                Ink(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(), color: kcPrimaryColor),
                  child: _focusNode.hasFocus || _focusNode.hasPrimaryFocus
                      ? IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 26,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: _sendSms)
                      : IconButton(
                          icon: Icon(
                            Icons.mic,
                            size: 26,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {}),
                ),
                SizedBox(width: kpMsgVertical),
              ],
            ),
            SizedBox(height: 10),
            Visibility(
              visible: _isBtnMorePressed,
              child: Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () => buildSnippetsMBS(context, _snippets),
                        customBorder: RoundedRectangleBorder(
                          borderRadius: kr10,
                        ),
                        child: Container(
                          width: itemWidth,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kpMsgHorizontal / 2,
                            vertical: kpItemVertical,
                          ),
                          decoration: BoxDecoration(
                            color: kcWhite14,
                            borderRadius: kr10,
                          ),
                          child: Column(children: [
                            Icon(
                              Icons.quickreply_rounded,
                              size: 36,
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Trả lời nhanh',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Theme.of(context).accentColor),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {},
                        customBorder: RoundedRectangleBorder(
                          borderRadius: kr10,
                        ),
                        child: Container(
                          width: itemWidth,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kpMsgHorizontal / 2,
                            vertical: kpItemVertical,
                          ),
                          decoration: BoxDecoration(
                            color: kcWhite14,
                            borderRadius: kr10,
                          ),
                          child: Column(children: [
                            Icon(
                              Icons.contacts_rounded,
                              size: 36,
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Danh bạ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Theme.of(context).accentColor),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future buildSnippetsMBS(BuildContext context, _snippets) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  top: kpDefaultPadding / 2,
                  left: 8,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 26,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kpDefaultPadding),
                  child: Center(
                      child: Text(
                    'Trả lời nhanh',
                    style: Theme.of(context).textTheme.headline5,
                  )),
                ),
              ],
            ),
            Divider(height: 1, color: Theme.of(context).colorScheme.background),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, _) => Divider(
                  color: Theme.of(context).colorScheme.background,
                ),
                itemCount: _snippets.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    _textEditingController.text = _snippets[index];
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: kpMsgHorizontal, vertical: kpMsgVertical),
                    child: Text(
                      _snippets[index],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
