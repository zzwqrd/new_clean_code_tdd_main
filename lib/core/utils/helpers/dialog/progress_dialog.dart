import 'package:flutter/material.dart';

import '../spinkit_indicator.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    super.key,
    required this.title,
    required this.isProgressed,
    this.onPressed,
  });

  final String title;
  final bool isProgressed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      title: const Center(child: Text("Please wait")),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          const SizedBox(height: 15),
          isProgressed
              ? const SpinKitIndicator(type: SpinKitType.circle)
              : const SizedBox(),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: isProgressed
                ? const SizedBox()
                : ElevatedButton(
                    onPressed: onPressed,
                    child: const Text("Success"),
                  ),
          )
        ],
      ),
    );
  }
}
