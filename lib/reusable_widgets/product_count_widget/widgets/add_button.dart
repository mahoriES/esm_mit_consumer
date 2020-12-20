part of '../product_count_widget.dart';

// A part of ProductCountWidget
// used when product count is 0.
class _AddButton extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback buttonAction;
  const _AddButton({
    @required this.isDisabled,
    @required this.buttonAction,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.toWidth,
      width: 73.toWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: CustomTheme.of(context).colors.primaryColor,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () async {
          if (isDisabled) {
            Fluttertoast.showToast(msg: 'Item not in stock!');
            return;
          }
          buttonAction();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Icon(
                Icons.add,
                color: CustomTheme.of(context).colors.primaryColor,
                size: 14,
              ),
            ),
            SizedBox(width: 4.toWidth),
            Flexible(
              child: FittedBox(
                child: Text(
                  tr("new_changes.add"),
                  style: CustomTheme.of(context).textStyles.cardTitle.copyWith(
                        color: CustomTheme.of(context).colors.primaryColor,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
