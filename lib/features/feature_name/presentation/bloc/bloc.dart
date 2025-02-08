import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../domain/usecases/usecase_name.dart';
import 'event.dart';
import 'state.dart';

class RegisterBloc extends Bloc<RegisterEvents, RegisterStates> {
  RegisterBloc({required this.productUseCaseImp}) : super(RegisterStates()) {
    on<RegisterStartEvents>(register);
  }

  final ProductUseCaseImp productUseCaseImp;

  void register(RegisterStartEvents event, Emitter<RegisterStates> emit) async {
    emit(RegisterLoadingState());
    final res = await ProductUseCaseImp().register();
    res.fold((l) {
      if (l.statusCode == 405) {
        showErrorDialogue(l.message);
      } else {
        showErrorDialogue(l.message);
      }
      emit(RegisterFailState(msg: l.message, statusCode: l.statusCode));
    }, (r) {
      emit(RegisterSuccessState(model: r!, msg: r.message));
    });
  }
}

showErrorDialogue(String error) {
  showDialog(
    context: navigator.currentContext!,
    builder: (context) => ErrorAlertDialogueWidget(
      title: error,
    ),
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
          child: Text("ok"),
          onTap: () => Navigator.pop(context),
        )
      ],
    );
  }
}
