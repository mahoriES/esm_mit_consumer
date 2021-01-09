part of '../product_count_widget.dart';

// A part of ProductCountWidget
// used when product count is nonZero.
class _StepperButton extends StatelessWidget {
  final int count;
  final Function(bool isAddAction) buttonAction;
  const _StepperButton({
    Key key,
    @required this.count,
    @required this.buttonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.toHeight,
      width: 75.toWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: InkWell(
              onTap: () => buttonAction(false),
              child: Container(
                height: 30.toHeight,
                width: 30.toWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CustomTheme.of(context).colors.primaryColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.remove,
                    color: CustomTheme.of(context).colors.primaryColor,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.toWidth),
              child: FittedBox(
                child: Text(
                  count.toString(),
                  style: CustomTheme.of(context).textStyles.cardTitle.copyWith(
                      color: CustomTheme.of(context).colors.primaryColor),
                ),
              ),
            ),
          ),
          Flexible(
            child: InkWell(
              onTap: () => buttonAction(true),
              child: Container(
                height: 30.toHeight,
                width: 30.toWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CustomTheme.of(context).colors.primaryColor,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: CustomTheme.of(context).colors.primaryColor,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
