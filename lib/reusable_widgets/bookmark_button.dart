import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/merchant_response.dart';
import 'package:eSamudaay/modules/store_details/actions/categories_actions.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/redux/states/home_page_state.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

///The [BookmarkButton] widget, is an animated button, used to show the bookmark status for the merchant
///It also allows toggling the status of the same for the merchant

class BookmarkButton extends StatefulWidget {
  ///Unique identity of the business
  ///For changing the bookmark status of the required merchant is changed in the
  ///main list of merchants held in the [HomePageState]
  ///The ViewModels listening to that list are all rebuilt when bookmark status is altered
  ///for any business and so are StoreConnectors and dumb-widgets.
  final String businessId;

  const BookmarkButton({Key key, @required this.businessId})
      : assert(businessId != null),
        super(key: key);

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          final Business business =
              snapshot.businessesDataSource[widget.businessId];
          return Container(
            child: GestureDetector(
              onTap: () {
                snapshot.bookmarkMerchantAction(widget.businessId);
                //When the bookmark button is tapped, we toggle the status while the animations continues
                _controller.forward();
              },
              child: Transform.scale(
                scale: _animation.value,
                child: Icon(
                  Icons.bookmark,
                  size: 28,
                  color: business.isBookmarked
                      ? CustomTheme.of(context).colors.primaryColor
                      : CustomTheme.of(context)
                          .colors
                          .primaryColor
                          .withOpacity(0.3),
                ),
              ),
            ),
          );
        });
  }
}

class _ViewModel extends BaseModel<AppState> {
  Function(String) bookmarkMerchantAction;
  Map<String, Business> businessesDataSource;
  LoadingStatusApp loadingStatusApp;

  _ViewModel();

  _ViewModel.build(
      {this.bookmarkMerchantAction,
      this.businessesDataSource,
      this.loadingStatusApp})
      : super(equals: [businessesDataSource, loadingStatusApp]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      loadingStatusApp: state.authState.loadingStatus,
      businessesDataSource: state.homePageState.businessDS,
      bookmarkMerchantAction: (String businessId) async {
        final Business business =
            state.homePageState.businessDS[businessId];
        if (business.isBookmarked)
          await dispatchFuture(
              UnBookmarkBusinessAction(businessId: businessId));
        else
          await dispatchFuture(
              BookmarkBusinessAction(businessId: businessId));
      },
    );
  }
}
