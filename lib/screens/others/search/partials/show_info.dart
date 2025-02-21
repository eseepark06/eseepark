import 'package:eseepark/globals.dart';
import 'package:flutter/material.dart';

import '../../../../models/establishment_model.dart';

class ShowInfo extends StatefulWidget {
  final Establishment selectedEstablishment;

  const ShowInfo({
    super.key,
    required this.selectedEstablishment
  });

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text('Establishment Info',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
