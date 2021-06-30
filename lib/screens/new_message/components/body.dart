import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:message_bigtext_app/blocs/font_size_factor/bloc.dart';
import 'package:message_bigtext_app/blocs/message/bloc.dart';
import 'package:message_bigtext_app/blocs/message/event.dart';
import 'package:message_bigtext_app/models/Chat.dart';
import 'package:message_bigtext_app/models/ContactProfile.dart';
import 'package:message_bigtext_app/repos/contact_repo.dart';
import 'package:message_bigtext_app/repos/message_repo.dart';
import 'package:message_bigtext_app/screens/contact_list/contact_list_screen.dart';
import 'package:message_bigtext_app/screens/messages/message_screen.dart';
import 'package:message_bigtext_app/widgets/avatar.dart';
import 'package:message_bigtext_app/widgets/chat_input_field.dart';
import 'package:message_bigtext_app/widgets/contact_item.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final MessageBloc _messageBloc = MessageBloc(repo: MessageRepo());

  final TextEditingController _textEditingController = TextEditingController();

  List<ContactProfile> _contactList = [];

  _onSendCallback(BuildContext context, String message) {
    Chat _chat = Chat(message: message);
    _messageBloc.add(MessagesInitEvent(chat: _chat));
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (context) => _messageBloc,
          child: MessageScreen(),
        );
      },
    ));
  }

  @override
  void initState() {
    super.initState();
    // BlocListener(listener: listener)
    // BlocProvider.of<MessageBloc>(context).
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kpMsgVertical / 2),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50 * BlocProvider.of<FontSizeBloc>(context).state.size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: kr10,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: kpMsgVertical,
                    vertical: kpItemHorizontal / 2,
                  ),
                  child: Text(
                    'Sđt:',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    // height: 100,
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: true,
                        controller: _textEditingController,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            letterSpacing: 0.85, fontWeight: FontWeight.w400),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          // hintText: '',
                          border: InputBorder.none,
                        ),
                        onEditingComplete: () {},
                        onSubmitted: (value) {
                          if (value.isEmpty) return;

                          setState(() => _contactList.insert(
                              0, ContactProfile(address: value)));

                          _textEditingController.clear();
                        },
                      ),
                      hideSuggestionsOnKeyboardHide: false,
                      hideOnEmpty: true,
                      // suggestionsBoxDecoration:
                      //     SuggestionsBoxDecoration(hasScrollbar: false),
                      itemBuilder: (context, itemData) => ListTile(
                        leading: Avatar(
                          radius: 34,
                          profile: ContactProfile(
                            fullName: itemData.fullName,
                            thumbnail: itemData.thumbnail,
                          ),
                        ),
                        title: Text(
                          itemData.fullName ?? 'Không tên',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        subtitle: Text(
                          itemData.address,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      onSuggestionSelected: (ContactProfile suggestion) {
                        setState(() => _contactList.add(suggestion));
                      },
                      suggestionsCallback: (String pattern) =>
                          RepositoryProvider.of<ContactRepo>(context)
                              .queryContacts(pattern),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kcPrimaryColor,
                    borderRadius: kr10.subtract(
                      BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.group_add_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactListScreen()),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _contactList.length,
              itemBuilder: (context, index) => ContactItem(
                profile: _contactList[index],
                tabCallback: () {},
              ),
            ),
          ),
          ChatInputField(
            sendCallback: _onSendCallback,
          )
        ],
      ),
    );
  }
}
