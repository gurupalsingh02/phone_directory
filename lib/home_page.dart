// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, non_constant_identifier_names, prefer_is_empty
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_directory/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:permission_asker/permission_asker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts_search = [];
  TextEditingController search_controller = new TextEditingController();
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
    super.initState();
    search_controller.addListener(() {
      search_by_name();
    });
  }

  sort_by_name() {}
  sort_by_number() {}
  search_by_name() {
    contacts_search.addAll(_contacts);
    if (search_controller.text.isNotEmpty) {
      contacts_search.retainWhere((contact) {
        return contact.displayName!
            .toLowerCase()
            .contains(search_controller.text.toLowerCase());
      });
    }
    (VxState.store as MyStore).contacts = contacts_search;
    setState(() {});
  }

  search_by_number() {}

  @override
  Widget build(BuildContext context) {
    bool issearching = search_controller.text.length == 0 ? false : true;
    (VxState.store as MyStore).contacts =
        issearching ? contacts_search : _contacts;
    for (int i = 0; i < (VxState.store as MyStore).contacts.length; i++) {
      if ((VxState.store as MyStore).contacts.elementAt(i).phones!.isEmpty ||
          (VxState.store as MyStore)
              .contacts
              .elementAt(i)
              .displayName!
              .isEmpty) {
        ContactsService.deleteContact(
            (VxState.store as MyStore).contacts.elementAt(i));
        (VxState.store as MyStore)
            .contacts
            .remove((VxState.store as MyStore).contacts.elementAt(i));
      }
    }
    return contacts_are_loaded
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
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
                                      .make()
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
