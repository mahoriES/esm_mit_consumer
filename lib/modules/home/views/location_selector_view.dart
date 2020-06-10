//import 'package:async_redux/async_redux.dart';
//import 'package:esamudaayapp/redux/states/app_state.dart';
//import 'package:flutter/material.dart';
//import 'package:fresh_net/redux/states/app_state.dart';
//import 'package:geolocator/geolocator.dart';
//
//class LocationSelector extends StatelessWidget {
//  const LocationSelector({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, _ViewModel>(
//        model: _ViewModel(),
//        builder: (context, snapshot) {
//          return Container(
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Icon(
//                      Icons.my_location,
//                      size: 16,
//                    ),
//                  ),
//                ),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      child: Container(),
//                    ),
//                    Expanded(
//                      child: InkWell(
//                        onTap: () {
//                          snapshot.navigateToManageAddressPage();
//                        },
//                        child: Row(
//                          children: <Widget>[
//                            Expanded(
//                              flex: 0,
//                              child: Text(
//                                  snapshot.currentLocation?.locality ?? "",
//                                  maxLines: 1,
//                                  overflow: TextOverflow.ellipsis,
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontWeight: FontWeight.w400,
//                                      fontFamily: "JTLeonor",
//                                      fontStyle: FontStyle.normal,
//                                      fontSize: 16.0),
//                                  textAlign: TextAlign.center),
//                            ),
//                            Icon(Icons.keyboard_arrow_down)
//                          ],
//                        ),
//                      ),
//                    ),
//                    Expanded(
//                      child: Container(),
//                    ),
//                  ],
//                )
//              ],
//            ),
//          );
//        });
//  }
//}
//
//class _ViewModel extends BaseModel<AppState> {
//  _ViewModel();
//  Placemark currentLocation;
//  Function navigateToManageAddressPage;
//  _ViewModel.build({this.navigateToManageAddressPage, this.currentLocation})
//      : super(equals: [currentLocation]);
//
//  @override
//  BaseModel fromStore() {
//    // TODO: implement fromStore
//    return _ViewModel.build(
//        currentLocation: state.addressState.currentLocation,
//        navigateToManageAddressPage: () {
//          dispatch(NavigateAction.pushNamed('/ManageAddresses'));
//        });
//  }
//}
