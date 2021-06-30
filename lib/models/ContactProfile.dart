import 'package:sms/contact.dart';

class ContactProfile {
  String _fullName;
  Photo _thumbnail;
  String _address;
  String _image;

  ContactProfile(
      {String fullName, Photo thumbnail, String address, String image})
      : this._fullName = fullName,
        this._thumbnail = thumbnail,
        this._address = address,
        this._image = image;

  String get fullName => this._fullName;
  Photo get thumbnail => this._thumbnail;
  String get address => this._address;
  String get image => this._image;

  static ContactProfile fromContact(Contact contact) {
    return ContactProfile(
      fullName: contact.fullName,
      thumbnail: contact.thumbnail ?? contact.photo,
      address: contact.address,
    );
  }

  @override
  String toString() {
    return "fullName: $fullName, address: $address";
  }
}
