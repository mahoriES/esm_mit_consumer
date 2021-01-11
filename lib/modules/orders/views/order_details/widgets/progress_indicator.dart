import 'package:eSamudaay/modules/orders/models/order_state_data.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class OrderProgressIndicator extends StatefulWidget {
  final OrderStateData stateData;
  const OrderProgressIndicator(this.stateData, {Key key}) : super(key: key);

  @override
  _OrderProgressIndicatorState createState() => _OrderProgressIndicatorState();
}

class _OrderProgressIndicatorState extends State<OrderProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    double endAnimationValue =
        widget.stateData.stateProgressBreakPoint.toDouble();

    controller = AnimationController(
      duration: Duration(
        seconds: widget.stateData.isOrderCancelled ? 0 : 1,
      ),
      vsync: this,
    );
    animation = Tween(
      begin: 0.0,
      end: endAnimationValue,
    ).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 26,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: CustomTheme.of(context).colors.placeHolderColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _StateProgressBar(
                      animationValue: animation.value,
                      stateData: widget.stateData,
                    ),
                  ),
                ),
                if (animation.isCompleted &&
                    widget.stateData.isOrderCompleted) ...{
                  _CompletedOrderIconWidget()
                }
              ],
            ),
          ),
          const SizedBox(height: 20),
          _StateProgressTagsRow(widget.stateData),
        ],
      ),
    );
  }
}

class _CompletedOrderIconWidget extends StatelessWidget {
  const _CompletedOrderIconWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 26,
        width: 26,
        decoration: BoxDecoration(
          color: CustomTheme.of(context).colors.positiveColor,
          shape: BoxShape.circle,
        ),
        child: Container(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: CustomTheme.of(context).colors.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.check_sharp,
              color: CustomTheme.of(context).colors.positiveColor,
              size: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _StateProgressTagsRow extends StatelessWidget {
  final OrderStateData stateData;
  const _StateProgressTagsRow(this.stateData, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        stateData.stateProgressTagsList.length,
        (index) => Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 10),
          child: FittedBox(
            child: Text(
              stateData.stateProgressTagsList[index],
              style: CustomTheme.of(context).textStyles.body1.copyWith(
                    color: index == stateData.stateProgressBreakPoint
                        ? stateData.stateProgressTagColor
                        : CustomTheme.of(context).colors.textColor,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }
}

class _StateProgressBar extends StatelessWidget {
  final double animationValue;
  final OrderStateData stateData;

  const _StateProgressBar({
    @required this.animationValue,
    @required this.stateData,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        stateData.stateProgressTagsList.length - 1,
        (index) => Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: animationValue == index + 1 ||
                        stateData.animationBreakPoint == index + 1
                    ? BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      )
                    : BorderRadius.zero,
                child: LinearProgressIndicator(
                  value: animationValue < index ? 0 : (animationValue - index),
                  minHeight: 16,
                  valueColor: AlwaysStoppedAnimation(
                    stateData.animationBreakPoint == index
                        ? CustomTheme.of(context).colors.placeHolderColor
                        : stateData.isOrderCancelled
                            ? CustomTheme.of(context).colors.placeHolderColor
                            : CustomTheme.of(context).colors.positiveColor,
                  ),
                  backgroundColor:
                      CustomTheme.of(context).colors.placeHolderColor,
                ),
              ),
              if (animationValue <= (index + 1)) ...{
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 16,
                    width: 16,
                    margin: EdgeInsets.all(0.5),
                    decoration: BoxDecoration(
                      color: animationValue == (index + 1)
                          ? stateData.stateProgressBreakPointColor
                          : CustomTheme.of(context).colors.disabledAreaColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
