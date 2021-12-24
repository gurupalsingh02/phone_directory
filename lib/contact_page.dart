// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:phone_directory/store.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contact _contact = (VxState.store as MyStore).currentcontact;
    return Material(
        child: SafeArea(
      child: Column(
        children: [
          CircleAvatar(
                  radius: 40, child: Icon(Icons.contacts).scale(scaleValue: 2))
              .p12(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Name :".text.bold.xl2.make().p12(),
                  "Contact :".text.bold.xl2.make().p12(),
                ],
              ).p8(),
              Column(
                children: [
                  (VxState.store as MyStore)
                      .currentcontact
                      .displayName
                      .toString()
                      .text
                      .make()
                      .p8()
                      .box
                      .border()
                      .make()
                      .w56(context)
                      .p8(),
                  (VxState.store as MyStore)
                      .currentcontact
                      .phones!
                      .elementAt(0)
                      .value
                      .toString()
                      .text
                      .make()
                      .box
                      .p8
                      .border()
                      .make()
                      .w56(context)
                      .p8()
                ],
              ),
            ],
          ).py(40),
          IconButton(
                  onPressed: () {
                    ContactsService.deleteContact(
                        (VxState.store as MyStore).currentcontact);
                  },
                  icon: Icon(Icons.delete).scale(scaleValue: 2))
              .centered()
        ],
      ).py(20),
    ));
  }
}
