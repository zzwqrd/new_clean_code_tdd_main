import '../../data/models/model.dart';
import 'bloc.dart';

class RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  final RegisterModel model;
  final String msg;
  RegisterSuccessState({
    required this.model,
    required this.msg,
  }) {
    showErrorDialogue(msg);
  }
}

class RegisterFailState extends RegisterStates {
  int statusCode;
  String msg;
  RegisterFailState({
    required this.statusCode,
    required this.msg,
  });
}
