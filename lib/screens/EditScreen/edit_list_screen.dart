import 'package:flutter/material.dart';

class EditListScreen extends StatelessWidget {
  const EditListScreen({
    Key? key,
    this.description,
    this.date,
  }) : super(key: key);

  final String? description;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(date.toString()), centerTitle: true),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description.toString(),
              style: const TextStyle(fontSize: 25),
            ),
          )
        ],
      )),
    );
  }
}
