import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:flutter/material.dart';

///The [BookmarkButton] widget, is an animated button, used to show the bookmark status for the merchant
///It also allows toggling the status of the same for the merchant

class BookmarkButton extends StatefulWidget {
  const BookmarkButton({Key key}) : super(key: key);

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _animation = Tween<double>(begin: 1.0, end: 0.6).animate(CurvedAnimation(
        parent: _controller, curve: Curves.linear, reverseCurve: Curves.linear))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        //By reversing the _controller we go back from the shrank icon to its original size
        if (status == AnimationStatus.completed) _controller.reverse();
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    debugPrint('Closing dialog');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          debugPrint(snapshot.isBusinessBookmarked.toString());
          return Container(
            child: GestureDetector(
              onTap: () {
                snapshot.bookmarkMerchantAction();
                //When the bookmark button is tapped, we toggle the status while the animations continues
                //this.isBookmarked = !this.isBookmarked;
                _controller.forward();
              },
              child: Transform.scale(
                scale: _animation.value,
                child: Icon(
                  Icons.bookmark,
                  color: snapshot.isBusinessBookmarked
                      ? AppColors.blueBerry
                      : AppColors.blueBerry.withOpacity(0.3),
                ),
              ),
            ),
          );
        });
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function bookmarkMerchantAction;
  bool isBusinessBookmarked;

  _ViewModel();

  _ViewModel.build({this.isBusinessBookmarked, this.bookmarkMerchantAction})
      : super(equals: [
          isBusinessBookmarked,
        ]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      isBusinessBookmarked: state.productState.selectedMerchant.isBookmarked,
      bookmarkMerchantAction: () async {
        if (state.productState.selectedMerchant.isBookmarked)
          await dispatchFuture(UnBookmarkBusinessAction(
              businessId: state.productState.selectedMerchant.businessId));
        else
          await dispatchFuture(BookmarkBusinessAction(
              businessId: state.productState.selectedMerchant.businessId));
      },
    );
  }
}
