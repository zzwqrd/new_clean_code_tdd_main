import 'package:flutter/material.dart';

import '../../AnimationApp_dialog.dart';
import '../../main.dart';

void showErrorDialogue(String error) {
  showGeneralDialog(
    context: navigator.currentContext!,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation1, animation2) => const SizedBox(),
    transitionBuilder: (context, animation1, animation2, child) {
      return AnimationappDialog(
        duration: const Duration(milliseconds: 200),
        animationType: 'zoomIn',
        child: ErrorAlertDialogueWidget(title: error),
      );
    },
  );
}

class ErrorAlertDialogueWidget extends StatelessWidget {
  final String title;
  const ErrorAlertDialogueWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF282F37),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        InkWell(
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
