// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contact _contact = (VxState.store as MyStore).currentcontact;
    return Material(
        child: Column(
      children: [
        CircleAvatar(
          child: Icon(Icons.account_circle).w40(context),
        ),
        TextField(),
        Row(
          children: ["Name".text.make()],
        )
      ],
    ));
  }
}
