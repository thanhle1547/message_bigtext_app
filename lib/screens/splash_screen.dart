import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_bigtext_app/blocs/chat_list/cubit.dart';
import 'package:message_bigtext_app/blocs/pin_chat/bloc.dart';
import 'package:message_bigtext_app/constants.dart';
import 'package:message_bigtext_app/repos/chat_repo.dart';
import 'package:message_bigtext_app/repos/contact_repo.dart';
import 'package:message_bigtext_app/repos/pin_chat_repo.dart';
import 'package:message_bigtext_app/screens/chats/chats_screen.dart';
import 'package:message_bigtext_app/utils/services/local_storage_service.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();

    // Future.sync(() => Preferences.init()).then(
    //   (value) => Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => ChatsScreen()),
    //   ),
    // );

    // Timer(
    //   Duration(milliseconds: 300),
    //   () => Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => GestureDetector(
    //         onTap: () {
    //           FocusScope.of(context).unfocus();
    //         },
    //         child: ChatsScreen(),
    //       ),
    //     ),
    //   ),
    // );

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Preferences.init();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            // {
            // FocusScope.of(context).unfocus();
            // },
            child: RepositoryProvider(
              create: (_) => ContactRepo(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => ChatListCubit(repo: ChatRepo())..getAll(),
                  ),
                  BlocProvider(
                    create: (context) => PinChatBloc(
                      pinRepo: PinChatRepo(),
                      contactRepo: RepositoryProvider.of<ContactRepo>(context),
                    ),
                  ),
                ],
                child: ChatsScreen(),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.message_rounded,
                        size: 90,
                      ),
                      SizedBox(height: kpDefaultPadding),
                      Text(
                        'Tin nhắn',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white),
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
