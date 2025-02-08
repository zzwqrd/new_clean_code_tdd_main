import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

bool isDialogOpen = false;
void showMessage(String? text) {
  if (!isDialogOpen) {
    isDialogOpen = true;
    showDialog(
      context: navigator.currentContext!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(text!),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); //close Dialog
                isDialogOpen = false; // Reset the dialog state
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    ).then((_) {
      isDialogOpen = false; // Ensure the state is reset if dialog is dismissed
    });
  }
}
