import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/validators/validators.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String) onChanged;
  const InputField({
    @required this.hintText,
    @required this.controller,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.nullStringValidator,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0),
        border: UnderlineInputBorder(),
        hintText: hintText,
        hintStyle: CustomTheme.of(context).textStyles.body1Faded,
      ),
      style: CustomTheme.of(context).textStyles.body1,
    );
  }
}
