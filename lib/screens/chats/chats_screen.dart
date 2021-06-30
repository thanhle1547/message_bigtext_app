import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/blocs/pin_chat/bloc.dart';
import 'package:message_bigtext_app/constants.dart';
import 'package:message_bigtext_app/repos/contact_repo.dart';
import 'package:message_bigtext_app/repos/snippets_repo.dart';
import 'package:message_bigtext_app/screens/chats/components/body.dart';
import 'package:message_bigtext_app/screens/chats/components/check_all_btn.dart';
import 'package:message_bigtext_app/screens/new_message/new_message.dart';
import 'package:message_bigtext_app/screens/settings/settings_screen.dart';

import 'components/multi_select_item.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final MultiSelectController _multiSelectController = MultiSelectController();

  // _delete() {
  //   var list = _multiSelectController.selectedIndexes;
  //   list.sort((b, a) =>
  //       a.compareTo(b)); //reoder from biggest number, so it wont error
  //   list.forEach((element) {
  //     mainList.removeAt(element);
  //   });

  //   setState(() {
  //     _multiSelectController.set(mainList.length);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _multiSelectController.disableEditingWhenNoneSelected = false;
    BlocProvider.of<PinChatBloc>(context).add(LoadPinnedChatsEvent());
  }

  _exitMultiSelectMode() {
    setState(() {
      _multiSelectController.isSelecting = false;
    });
  }

  _onItemSelectCallback(int index) {
    setState(() {
      _multiSelectController.toggle(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _multiSelectController.isSelecting == false
          ? AppBar(
              title: Text('Tin nhắn'),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  ),
                ),
                SizedBox(width: 8.0),
              ],
            )
          : AppBar(
              actions: [
                CheckAllBtn(
                  onCheckCallback: () => setState(() {
                    _multiSelectController.selectAll();
                    // print(_multiSelectController.listLength);
                    // print(_multiSelectController.selectedIndexes.toString());
                  }),
                  onUnCheckCallback: () => setState(() {
                    _multiSelectController.deselectAll();
                  }),
                ),
                SizedBox(width: 8.0),
              ],
              leadingWidth: 88,
              leading: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Color(0x26FFFFFF)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(kpMsgVertical)),
                ),
                onPressed: _exitMultiSelectMode,
                // icon: Icon(
                //   Icons.chevron_left,
                //   size: 34,
                // ),
                child: Text(
                  'Hủy',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ),
            ),
      body: Body(
        multiSelectController: _multiSelectController,
        exitMultiSelectModeCallback: _exitMultiSelectMode,
        onItemSelectCallback: _onItemSelectCallback,
      ),
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0 &&
            _multiSelectController.isSelecting == false,
        child: FloatingActionButton(
          child: Icon(Icons.add, size: 36),
          backgroundColor: kcPrimaryColor,
          tooltip: 'Tin nhắn mới',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MultiRepositoryProvider(
                providers: [
                  RepositoryProvider.value(
                    value: RepositoryProvider.of<ContactRepo>(context),
                  ),
                  RepositoryProvider(
                    create: (_) => SnippetRepo(),
                  ),
                ],
                child: NewMessageScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
