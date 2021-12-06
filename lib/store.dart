import 'package:contacts_service/contacts_service.dart';
import 'package:velocity_x/velocity_x.dart';

class MyStore extends VxStore {
  List<Contact> contacts = [];
  Contact currentcontact = Contact();
  // ignore: empty_constructor_bodies
  MyStore() {
    currentcontact = Contact();
    contacts = [];
  }
}
