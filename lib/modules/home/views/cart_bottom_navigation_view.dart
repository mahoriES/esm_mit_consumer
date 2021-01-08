import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/material.dart';

class NavigationCartItem extends StatelessWidget {
  final Color backgroundColor;
  final Widget title;
  final Widget icon;

  NavigationCartItem({Key key, this.backgroundColor, this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 30.0,
              width: 30,
              child: icon,
            ),
            new Positioned(
              right: 1,
              top: 1,
              child: CartCount(builder: (context, vm) {
                return Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: vm.totalCount == 0 ? Colors.transparent : Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    (vm.totalCount).toString(),
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Center(child: title),
        )
      ],
    );
  }
}

class NavigationNotificationItem extends StatelessWidget {
  final Color backgroundColor;
  final Widget title;
  final Widget icon;

  const NavigationNotificationItem(
      {Key key, this.backgroundColor, this.title, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 30.0,
              width: 30,
              child: icon,
//              decoration: ShapeDecoration(
//                  shape: CircleBorder(
//                      side: BorderSide(width: 0.0, color: Color(0xffcbcbcb))),
//                  color: backgroundColor),
            ),
            new Positioned(
              right: 1,
              top: 1,
              child: new Container(
                padding: EdgeInsets.all(1),
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: CartCount(builder: (context, vm) {
                  return new Text(
                    "0",
//                    (vm.localCart.length).toString(),
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Center(child: title),
        )
      ],
    );
  }
}

class CartCount extends StatelessWidget {
  final Function(BuildContext context, _ViewModel count) builder;

  CartCount({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: builder,
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  List<Product> products;
  List<String> customerNoteImages;
  bool isImageUploading;
  _ViewModel();

  _ViewModel.build({
    this.products,
    this.customerNoteImages,
    this.isImageUploading,
  }) : super(equals: [products, isImageUploading]);
  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      products: state.cartState.localCartItems ?? [],
      customerNoteImages: state.cartState.customerNoteImages ?? [],
      isImageUploading: state.cartState.isImageUploading,
    );
  }

  int get totalCount => products.length + customerNoteImages.length;
}
