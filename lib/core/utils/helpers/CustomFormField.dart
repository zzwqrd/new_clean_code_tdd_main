import 'package:flutter/material.dart';

class CustomFormField<T> extends FormField<T> {
  final Widget Function(FormFieldState<T> state) builder;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final bool isEnabled;
  final bool isLoading;

  CustomFormField({
    Key? key,
    required this.builder,
    this.initialValue,
    this.onChanged,
    this.isEnabled = true,
    this.isLoading = false,
    FormFieldValidator<T?>? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          validator: validator,
          builder: (FormFieldState<T> state) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                builder(state),
                if (state.hasError)
                  Positioned(
                    left: 12,
                    bottom: 0,
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
