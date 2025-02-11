import 'package:eseepark/customs/custom_textfields.dart';
import 'package:flutter/material.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}
