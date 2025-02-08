import 'package:dartz/dartz.dart';

import 'failures.dart';

void failureHandler(
    Either<Failure, dynamic> result, void Function() onSuccess) {
  result.fold(
    (l) => showErrorDialogue(l.message ?? 'An error occurred'),
    (r) => onSuccess(),
  );
}

void showErrorDialogue(String message) {
  // Add your custom error dialogue implementation here
  print(message); // For simplicity, we're just printing the message
}
