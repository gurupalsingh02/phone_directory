// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, non_constant_identifier_names, prefer_is_empty, list_remove_unrelated_type
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_directory/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:permission_asker/permission_asker.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> list = [
    "sort by A-Z",
    "sort by Z-A",
    "sort by number",
    "sort by length of contact name"
  ];
  List<Contact> sorted_contacts = [];
  TextEditingController search_controller = TextEditingController();

  bool issearching = false;

  String search_text = "";

  bool contacts_are_loaded = false;

  List<Contact> _contacts = [];

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();

      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final PermissionStatus permissionStatus = await _getPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final Iterable<Contact> contacts = await ContactsService.getContacts();
        setState(() {
          _contacts = contacts.toList();
          (VxState.store as MyStore).contacts = _contacts;
          contacts_are_loaded = true;
        });
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.contacts,
        ].request();

        if (statuses[Permission.contacts] == PermissionStatus.granted) {
          final Iterable<Contact> contacts =
              await ContactsService.getContacts();
          setState(() {
            _contacts = contacts.toList();
            contacts_are_loaded = true;
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Permission to read contacts denied.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white);
        }
      }
    });
    search_controller.addListener(() {
      search_contact();
    });
    super.initState();
  }

  sort_by_A_to_Z() {
    int n = (VxState.store as MyStore).contacts.length;
    bool sorted;
    for (int i = 0; i < n - 1; i++) {
      sorted = true;
      for (int j = 0; j < n - 1 - i; j++) {
        if (((VxState.store as MyStore)
                    .contacts
                    .elementAt(j)
                    .displayName
                    .toString())
                .compareToIgnoringCase((VxState.store as MyStore)
                    .contacts
                    .elementAt(j + 1)
                    .displayName
                    .toString()) >
            0) {
          Contact temp = (VxState.store as MyStore).contacts[j];
          (VxState.store as MyStore).contacts[j] =
              (VxState.store as MyStore).contacts[j + 1];
          (VxState.store as MyStore).contacts[j + 1] = temp;
          sorted = false;
        }
      }
      if (sorted) {
        break;
      }
    }
  }

  sort_by_Z_to_A() {
    // aditya sharma
    int n = (VxState.store as MyStore).contacts.length;
    bool sorted;
    for (int i = 0; i < n - 1; i++) {
      sorted = true;
      for (int j = 0; j < n - 1 - i; j++) {
        if (((VxState.store as MyStore)
                    .contacts
                    .elementAt(j)
                    .displayName
                    .toString())
                .compareToIgnoringCase((VxState.store as MyStore)
                    .contacts
                    .elementAt(j + 1)
                    .displayName
                    .toString()) <
            0) {
          Contact temp = (VxState.store as MyStore).contacts[j];
          (VxState.store as MyStore).contacts[j] =
              (VxState.store as MyStore).contacts[j + 1];
          (VxState.store as MyStore).contacts[j + 1] = temp;
          sorted = false;
        }
      }
      if (sorted) {
        break;
      }
    }
  }

  sort_by_length_of_name() {
    int n = (VxState.store as MyStore).contacts.length;
    bool sorted;
    for (int i = 0; i < n - 1; i++) {
      sorted = true;
      for (int j = 0; j < n - 1 - i; j++) {
        if ((VxState.store as MyStore)
                .contacts
                .elementAt(j)
                .displayName
                .toString()
                .length >
            (VxState.store as MyStore)
                .contacts
                .elementAt(j + 1)
                .displayName
                .toString()
                .length) {
          Contact temp = (VxState.store as MyStore).contacts[j];
          (VxState.store as MyStore).contacts[j] =
              (VxState.store as MyStore).contacts[j + 1];
          (VxState.store as MyStore).contacts[j + 1] = temp;
          sorted = false;
        }
      }
      if (sorted) {
        break;
      }
    }
  }

  sort_by_number() {
    // sorted_contacts.addAll(sorted_contacts);

    int n = (VxState.store as MyStore).contacts.length;
    bool sorted;
    for (int i = 0; i < n - 1; i++) {
      sorted = true;
      for (int j = 0; j < n - 1 - i; j++) {
        if ((VxState.store as MyStore)
                .contacts
                .elementAt(j)
                .phones!
                .elementAt(0)
                .value
                .toString()
                .compareTo((VxState.store as MyStore)
                    .contacts
                    .elementAt(j + 1)
                    .phones!
                    .elementAt(0)
                    .value
                    .toString()) >
            0) {
          Contact temp = (VxState.store as MyStore).contacts[j];
          (VxState.store as MyStore).contacts[j] =
              (VxState.store as MyStore).contacts[j + 1];
          (VxState.store as MyStore).contacts[j + 1] = temp;
          sorted = false;
        }
      }
      if (sorted) {
        break;
      }
      // abhishek dhanger
    }
  }

  search_contact() {
    List<Contact> contacts_search = [];
    if (search_controller.text.isNotEmpty) {
      contacts_search.addAll(_contacts);
      contacts_search.retainWhere((contact) {
        bool name_match = contact.displayName!
            .toLowerCase()
            .contains(search_controller.text.toLowerCase());
        if (name_match) {
          return name_match;
        }
        String text = search_controller.text.toString();
        if (text.isEmpty) {
          return false;
        }
        text = text.replaceAll(RegExp(r'^(\+)|\D'), '');
        String phone = contact.phones!
            .elementAt(0)
            .value
            .toString()
            .replaceAll(RegExp(r'^(\+)|\D'), '');
        return phone.contains(text);
      });
      issearching = true;
      (VxState.store as MyStore).contacts = contacts_search;
    } else {
      (VxState.store as MyStore).contacts = _contacts;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    for (int i = 0; i < (VxState.store as MyStore).contacts.length; i++) {
      if ((VxState.store as MyStore)
              .contacts
              .elementAt(i)
              .phones!
              .elementAt(0)
              .value
              .toString()
              .isEmpty ||
          (VxState.store as MyStore)
              .contacts
              .elementAt(i)
              .displayName!
              .isEmpty ||
          (VxState.store as MyStore)
                  .contacts
                  .elementAt(i)
                  .phones!
                  .elementAt(0)
                  .value
                  .toString() ==
              null ||
          (VxState.store as MyStore).contacts.elementAt(i).displayName ==
              null) {
        ContactsService.deleteContact(
            (VxState.store as MyStore).contacts.elementAt(i));
        (VxState.store as MyStore)
            .contacts
            .remove((VxState.store as MyStore).contacts.elementAt(i));
      }
    }
    String? _value;
    return contacts_are_loaded
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: _value,
                        items: list
                            .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(item.toString()).onTap(() {
                                  _value = item;
                                })))
                            .toList(),
                        onChanged: (value) {
                          if (value.toString().compareTo("sort by number") ==
                              0) {
                            sort_by_number();
                          }
                          if (value.toString().compareTo("sort by Z-A") == 0) {
                            sort_by_Z_to_A();
                          }
                          if (value.toString().compareTo("sort by A-Z") == 0) {
                            sort_by_A_to_Z();
                          }
                          if (value.toString().compareTo(
                                  "sort by length of contact name") ==
                              0) {
                            sort_by_length_of_name();
                          }
                          setState(() {});
                        }).p4(),
                  ).p12(),
                  Container(
                    child: TextField(
                      controller: search_controller,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.lightBlue,
                          ),
                          labelText: "Search",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue))),
                    ),
                  ).p16(),
                  ListView.builder(
                      itemCount: (VxState.store as MyStore).contacts.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          child: VxBox(
                              child: Row(
                            children: [
                              Container(
                                child: CircleAvatar(
                                    child: Text((VxState.store as MyStore)
                                        .contacts[index]
                                        .initials()
                                        .characters
                                        .elementAt(0))),
                              ).p8(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (VxState.store as MyStore)
                                      .contacts[index]
                                      .displayName
                                      .toString()
                                      .text
                                      .ellipsis
                                      .xl
                                      .bold
                                      .make(),
                                  (VxState.store as MyStore)
                                      .contacts[index]
                                      .phones!
                                      .elementAt(0)
                                      .value
                                      .toString()
                                      .text
                                      .make(),
                                ],
                              )
                            ],
                          )).color(Colors.grey).roundedSM.p8.make().onTap(() {
                            (VxState.store as MyStore).currentcontact =
                                (VxState.store as MyStore).contacts[index];
                            Navigator.pushNamed(
                              context,
                              "/contact",
                            );
                          }),
                        ).p4();
                      }).p8().expand()
                ],
              ),
            ).p8())
        : Material(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contacts)
                      .iconColor(Colors.blue)
                      .scale(scaleValue: 4)
                      .p24(),
                  LinearProgressIndicator().w16(context).p20()
                ],
              ),
            ),
          );
  }
}
