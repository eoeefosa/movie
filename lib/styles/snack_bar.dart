import 'package:flutter/material.dart';

void showsnackBar(String message) {
  final messenger = scaffoldMessengerKey.currentState;
  messenger?.showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void hideSnackBar() {
  final messenger = scaffoldMessengerKey.currentState;
  messenger?.hideCurrentSnackBar();
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey(debugLabel: 'scaffoldMessengerKey');
