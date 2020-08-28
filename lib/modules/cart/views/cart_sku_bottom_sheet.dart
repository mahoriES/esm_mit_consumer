import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:eSamudaay/modules/store_details/views/stepper_view.dart';
import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/redux/states/app_state.dart';

class BottomSheet extends StatefulWidget {

  final String storeName;
  final String buttonTitle;
  final VoidCallback didPressDone;
  final int productIndex;

  const BottomSheet({
    Key key,
    this.buttonTitle,
    this.didPressDone,
    this.storeName,
    this.productIndex,
  }) : super(key:key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      builder: (context, snapshot) {

        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
            ),
            boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 5)],
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(flex: 80,child: Text(
                    widget.storeName,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Avenir',
                      fontSize: 18
                    ),
                  )),
                  Expanded(flex: 20,child: Center(
                    child: IconButton(
                        icon: Icon(Icons.close,color: Colors.grey,size: 22,),
                        onPressed: null
                    ),
                  )),
                ],
              ),
              mySeparator,
            ],
          ),
        );

      },
    );
  }

  Widget buildCustomizableItem({
    String title,int quantity,int price, String specificationName}) {

    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 60,
            child: Column(
              children: [
                Text(title,style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Avenir',
                  fontSize: 18,
                ),),
                SizedBox(height: 3,),
                Text(
                  '₹'+price.toString(),
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Avenir',
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 3,),
                Text(
                  'Quantity: $specificationName}',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Avenir',
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 40,
            child: Column(crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CSStepper(
                  value: quantity.toString(),
                  didPressAdd: null,
                  didPressRemove: null,
                ),
                SizedBox(height: 3,),
                Text(
                    '₹'+(quantity*price).toString(),
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Avenir',
                      fontSize: 18,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

  Widget get mySeparator => Padding(
    padding: EdgeInsets.all(20),
    child: Container(
      color: Colors.black54,
      height: 0.5,
    ),
  );
}

class _ViewModel extends BaseModel<AppState> {

  List<Product> products;
  VoidCallback didPressDone;

  _ViewModel();

  _ViewModel.build({
    this.products,
    this.didPressDone
  }) : super(equals: [products]);

  @override
  BaseModel fromStore() => _ViewModel.build(

    didPressDone: () {

    },
  );



}


