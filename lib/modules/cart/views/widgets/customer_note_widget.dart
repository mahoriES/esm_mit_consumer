part of "../cart.dart";

class _CustomerNoteWidget extends StatefulWidget {
  _CustomerNoteWidget({Key key}) : super(key: key);

  @override
  __CustomerNoteWidgetState createState() => __CustomerNoteWidgetState();
}

class __CustomerNoteWidgetState extends State<_CustomerNoteWidget> {
  final TextEditingController noteController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // color: Colors.red,
          border: Border(
            bottom: BorderSide(
                color: CustomTheme.of(context).colors.disabledAreaColor),
          ),
        ),
        child: Center(
          child: Container(
            width: SizeConfig.screenWidth / 1.8,
            child: TextField(
              expands: false,
              controller: noteController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Add a note for merchant",
                hintStyle: CustomTheme.of(context).textStyles.cardTitleFaded,
                prefixIcon: Icon(
                  Icons.edit,
                  color: CustomTheme.of(context).colors.disabledAreaColor,
                ),
              ),
              textAlign: TextAlign.center,
              selectionWidthStyle: BoxWidthStyle.tight,
            ),
          ),
        ),
      ),
    );
  }
}
