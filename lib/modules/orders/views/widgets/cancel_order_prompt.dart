import 'package:eSamudaay/presentations/custom_confirmation_dialog.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/validators/validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CancelOrderPrompt extends StatefulWidget {
  final Function(String) onCancel;
  const CancelOrderPrompt(this.onCancel, {Key key}) : super(key: key);

  @override
  _CancelOrderPromptState createState() => _CancelOrderPromptState();
}

class _CancelOrderPromptState extends State<CancelOrderPrompt> {
  final TextEditingController _controller = new TextEditingController();
  GlobalKey<FormState> formKey = new GlobalKey();
  bool isReasonStringEmpty;

  @override
  void initState() {
    isReasonStringEmpty = true;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomConfirmationDialog(
      title: isReasonStringEmpty
          ? tr("screen_order.what_went_wrong")
          : tr("screen_order.cancel_order"),
      positiveButtonText: tr("common.cancel"),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        margin: const EdgeInsets.only(bottom: 20),
        child: Form(
          key: formKey,
          child: TextFormField(
            maxLines: null,
            minLines: 1,
            autofocus: true,
            textInputAction: TextInputAction.done,
            controller: _controller,
            validator: Validators.nullStringValidator,
            decoration: InputDecoration(
              hintText: tr("screen_order.cancel_order_hint"),
            ),
            style: CustomTheme.of(context).textStyles.cardTitle,
            textAlign: TextAlign.center,
            onChanged: (value) {
              bool _isEmpty = value.isEmpty;
              if (_isEmpty != isReasonStringEmpty) {
                setState(() {
                  isReasonStringEmpty = _isEmpty;
                });
              }
            },
          ),
        ),
      ),
      positiveAction: () {
        if (!isReasonStringEmpty) {
          Navigator.pop(context);
          widget.onCancel(_controller.text);
        } else {
          formKey.currentState.validate();
        }
      },
      negativeButtonText: tr("common.back"),
      actionButtonColor: isReasonStringEmpty
          ? CustomTheme.of(context).colors.disabledAreaColor
          : CustomTheme.of(context).colors.secondaryColor,
    );
  }
}
