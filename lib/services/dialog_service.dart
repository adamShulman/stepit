
import 'package:flutter/material.dart';

class DialogService {

  static final DialogService _instance = DialogService._internal();
  factory DialogService() => _instance;
  DialogService._internal();

  bool _isDialogShowing = false;

  Future<void> showSingleDialog(BuildContext context, String title, String message) async {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              _isDialogShowing = false;
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> showSingleDialogToEndChallenge(BuildContext context, String title, String message, {required VoidCallback onCancel, required VoidCallback onEnd}) async {
    if (_isDialogShowing) return;

    _isDialogShowing = true;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              _isDialogShowing = false;
              Navigator.of(context).pop();
              onCancel();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _isDialogShowing = false;
              Navigator.of(context).pop();
              onEnd();
            },
            child: const Text("End challenge"),
          ),
        ],
      ),
    );
  }
}