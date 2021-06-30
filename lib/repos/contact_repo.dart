import 'dart:async';

import 'package:message_bigtext_app/models/ContactProfile.dart';
import 'package:message_bigtext_app/providers/contact_provider.dart';

class ContactRepo {
  ContactProvider _provider = ContactProvider();

  Future<ContactProfile> queryContact(String address) => _provider
      .queryContact(address)
      .then((value) => ContactProfile.fromContact(value));

  Future<List<ContactProfile>> queryContacts(String address) async =>
      <ContactProfile>[await queryContact(address)];

  Future<List<ContactProfile>> queryListContact(List<String> addresses) async {
    List<ContactProfile> result = [];
    for (var item in addresses) {
      result.add(await queryContact(item));
    }
    return result;
  }
}
