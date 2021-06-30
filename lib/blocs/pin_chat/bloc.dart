import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:message_bigtext_app/models/ContactProfile.dart';
import 'package:message_bigtext_app/repos/contact_repo.dart';
import 'package:message_bigtext_app/repos/pin_chat_repo.dart';

part 'event.dart';
part 'state.dart';

class PinChatBloc extends Bloc<PinChatEvent, PinChatState> {
  final PinChatRepo pinRepo;
  final ContactRepo contactRepo;
  Map<int, String> _pinned;
  Map<int, ContactProfile> _snapshot;

  PinChatBloc({this.pinRepo, this.contactRepo}) : super(PinChatInitial());

  @override
  Stream<PinChatState> mapEventToState(
    PinChatEvent event,
  ) async* {
    if (event is LoadPinnedChatsEvent) {
      _pinned = await pinRepo.get();
      List<ContactProfile> contacts =
          await contactRepo.queryListContact(_pinned.values.toList());
      int i = 0;
      // Map<int, ContactProfile> result = {
      //   for (var key in pinned.keys)
      //     key : contacts[i],
      // };
      _snapshot = {};
      _pinned.forEach((key, value) {
        _snapshot[key] = contacts[i];

        if (_snapshot[key] == null)
          _snapshot[key] = ContactProfile(fullName: value, address: value);

        i++;
      });

      yield* _reload();
    } else if (event is PinAChatEvent) {
      _pinned[event.threadId] = event.address;
      _snapshot[event.threadId] = await contactRepo.queryContact(event.address);

      // print('_snapshot[event.threadId] = ' +
      //     _snapshot[event.threadId].toString());
      if (_snapshot[event.threadId] == null)
        _snapshot[event.threadId] =
            ContactProfile(fullName: event.address, address: event.address);

      // print("threadId: ${event.threadId}");
      // print("address: ${event.address}");

      // yield PinAChatSuccess(profiles: _snapshot
      //     // threadId: event.threadId,
      //     // profile: await contactRepo.queryContact(event.address),
      //     );
      // // repo.set(profile)
      yield* _reload();
    } else if (event is PinChatsEvent) {
    } else if (event is UnPinAChatEvent) {
      _pinned.remove(event.threadId);
      _snapshot.remove(event.threadId);

      yield* _reload();
    } else if (event is UnPinChatsEvent) {}
  }

  Stream<PinChatState> _reload() async* {
    yield PinChatStateChanged();
    print("PinChatBloc: ${_snapshot.toString()}");
    yield PinnedChatLoadSuccess(profiles: _snapshot);
  }

  Future<void> close() async {
    pinRepo.set(_pinned);
    super.close();
  }
}
