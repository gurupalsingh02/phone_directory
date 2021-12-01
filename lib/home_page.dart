// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:permission_asker/permission_asker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var Contactsloaded = false;
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
          Contactsloaded = true;
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
            Contactsloaded = true;
          });
        } else {
          Fluttertoast.showToast(
              msg: 'Permission to read contacts denied.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.orange,
              textColor: Colors.white);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < _contacts.length; i++) {
      if (_contacts.elementAt(i).phones!.isEmpty) {
        _contacts.remove(_contacts.elementAt(i));
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      drawer: Drawer(),
      body: Contactsloaded
          ? Column(
              children: [
                ListView.builder(
                    itemCount: _contacts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: VxBox(
                            child: Row(
                          children: [
                            Container(
                              child: CircleAvatar(
                                  child: Text(_contacts[index].initials())),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _contacts[index]
                                    .displayName
                                    .toString()
                                    .text
                                    .ellipsis
                                    .xl
                                    .bold
                                    .make(),
                                _contacts[index]
                                    .phones!
                                    .elementAt(0)
                                    .value
                                    .toString()
                                    .text
                                    .make()
                              ],
                            ).p12()
                          ],
                        )).color(Colors.grey).make(),
                      ).p4();
                    }).p12().expand()
              ],
            )
          : CircularProgressIndicator().centered(),
    );
  }
}
