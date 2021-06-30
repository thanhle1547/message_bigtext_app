import 'package:sms/contact.dart';

class ContactProvider {
  final ContactQuery _query;

  ContactProvider() : _query = ContactQuery();

  Future<Contact> queryContact(String address) => _query.queryContact(address);
}
