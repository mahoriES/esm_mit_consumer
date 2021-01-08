import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class CustomPositionedDialog {
  static show({
    @required Widget content,
    @required GlobalKey key,
    @required BuildContext context,
    @required Size margin,
    bool dismissable = true,
  }) {
    final RenderBox _obj = key.currentContext.findRenderObject();
    final Offset _position = _obj.localToGlobal(Offset.zero);

    debugPrint("position => $_position");

    final Widget positionedChild = Stack(
      children: [
        Positioned(
          top: _position.dy - margin.height,
          left: _position.dx - margin.width,
          child: content,
        ),
      ],
    );

    return showGeneralDialog(
      barrierLabel: "Dismiss",
      barrierDismissible: dismissable,
      barrierColor: Colors.transparent,
      context: context,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => positionedChild,
      transitionBuilder: (context, anim1, anim2, child) {
        return AnimatedBuilder(
          animation: anim1,
          builder: (context, widget) {
            final curvedValue = Curves.easeOutQuint.transform(anim1.value);
            return Transform.scale(
              scale: curvedValue,
              child: child,
              alignment: _position != null
                  ? Alignment(
                      (2 * _position.dx - SizeConfig.screenWidth) /
                          SizeConfig.screenWidth,
                      (2 * _position.dy - SizeConfig.screenHeight) /
                          SizeConfig.screenHeight,
                    )
                  : Alignment.center,
            );
          },
          child: child,
        );
      },
    );
  }
}
