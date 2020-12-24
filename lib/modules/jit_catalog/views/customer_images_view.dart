// import 'dart:io';

// import 'package:async_redux/async_redux.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:eSamudaay/models/loading_status.dart';
// import 'package:eSamudaay/modules/jit_catalog/actions/customer_images_actions.dart';
// import 'package:eSamudaay/redux/states/app_state.dart';
// import 'package:eSamudaay/utilities/colors.dart';
// import 'package:eSamudaay/utilities/widget_sizes.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// ///This class implements the picker view for the customer note images.
// ///Up to 5 images are allowed to be added by the customer.

// class CustomerNoteImagePicker extends StatefulWidget {
//   @override
//   _CustomerNoteImagePickerState createState() =>
//       _CustomerNoteImagePickerState();
// }

// class _CustomerNoteImagePickerState extends State<CustomerNoteImagePicker> {
//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, _ViewModel>(
//       model: _ViewModel(),
//       builder: (context, snapshot) {
//         return buildImagesTile(snapshot);
//       },
//     );
//   }

//   Widget buildNoImageTile(BuildContext context, _ViewModel snapshot) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//               icon: Icon(
//                 Icons.add_circle,
//                 color: AppColors.icColors,
//                 size: AppSizes.productItemIconSize,
//               ),
//               onPressed: () {
//                 showNativeBottomSheet(context, snapshot);
//               }),
//         ],
//       ),
//     );
//   }

//   Widget buildImageViewTile(
//       {String imageUrl,
//       double height,
//       double width,
//       int index,
//       _ViewModel snapshot}) {
//     return GestureDetector(
//       onTap: () => showImageInFullScreenMode(imageUrl, snapshot),
//       child: SizedBox(
//         height: height,
//         width: width,
//         child: Stack(
//           children: <Widget>[
//             Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                 padding: EdgeInsets.all(10),
//                 child: Container(
//                   height: height,
//                   width: width,
//                   decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                             blurRadius: 7, color: AppColors.blackShadowColor)
//                       ],
//                       borderRadius: BorderRadius.circular(
//                           AppSizes.productItemBorderRadius),
//                       color: Colors.grey[100]),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(14),
//                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                     child: CachedNetworkImage(
//                       imageUrl: imageUrl,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => Center(
//                         child: SizedBox(
//                           height: width / 3,
//                           width: width / 3,
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () {
//                   snapshot.removeCustomerImageAction(index);
//                 },
//                 child: Container(
//                   child: Icon(
//                     Icons.close,
//                     size: width / 8,
//                     color: AppColors.solidWhite,
//                   ),
//                   height: width / 6,
//                   width: width / 6,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(width / 8),
//                       color: AppColors.iconColors,
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.blackShadowColor,
//                           blurRadius: 3.0,
//                         )
//                       ]),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildAddImageEmptyTile(
//       double height, double width, BuildContext context, _ViewModel snapshot) {
//     return SizedBox(
//       height: height,
//       width: width,
//       child: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.topCenter,
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Container(
//                 height: height,
//                 width: width,
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: 7, color: AppColors.blackShadowColor)
//                     ],
//                     borderRadius:
//                         BorderRadius.circular(AppSizes.productItemBorderRadius),
//                     color: Colors.grey[100]),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(14),
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   child: buildNoImageTile(context, snapshot),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildImagesTile(_ViewModel snapshot) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppSizes.sliverPadding),
//       child: Container(
//         padding: EdgeInsets.only(
//           top: 10,
//         ),
//         decoration: BoxDecoration(
//           color: AppColors.solidWhite,
//           borderRadius: BorderRadius.circular(AppSizes.productItemBorderRadius),
//           boxShadow: [
//             BoxShadow(
//                 blurRadius: AppSizes.shadowBlurRadius,
//                 color: AppColors.blackShadowColor)
//           ],
//         ),
//         child: Column(
//           children: [
//             GridView.count(
//               shrinkWrap: true,
//               physics: ClampingScrollPhysics(),
//               childAspectRatio: 2 / 2.75,
//               padding: EdgeInsets.all(8),
//               mainAxisSpacing: 10,
//               crossAxisSpacing: 10.0,
//               crossAxisCount: 2,
//               children: List.generate(
//                   snapshot.customerNoteImages.length == 5
//                       ? 5
//                       : snapshot.customerNoteImages.length + 1, (index) {
//                 if (index <= snapshot.customerNoteImages.length - 1) {
//                   return GridTile(
//                     child: buildImageViewTile(
//                         index: index,
//                         snapshot: snapshot,
//                         width: MediaQuery.of(context).size.width / 3,
//                         height: MediaQuery.of(context).size.width / 3,
//                         imageUrl: snapshot.customerNoteImages[index]),
//                   );
//                 } else {
//                   return GestureDetector(
//                       onTap: () {
//                         showNativeBottomSheet(context, snapshot);
//                       },
//                       child: GridTile(
//                         child: buildAddImageEmptyTile(
//                             MediaQuery.of(context).size.width / 3,
//                             MediaQuery.of(context).size.width / 3,
//                             context,
//                             snapshot),
//                       ));
//                 }
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ///This function shows a bottom sheet for picking the source for the customer
//   ///note images depending on your mobile OS. Hence for Android and iOS different native components are
//   ///displayed.
//   void showNativeBottomSheet(BuildContext context, _ViewModel snapshot) {
//     if (Platform.isAndroid) {
//       ///For android
//       showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             child: new Wrap(
//               children: <Widget>[
//                 new ListTile(
//                     leading: new Icon(Icons.camera_alt),
//                     title: new Text('Click a photo'),
//                     onTap: () {
//                       snapshot.addNewCustomerNotePhotoAction(0);
//                       snapshot.closeWindowAction();
//                     }),
//                 new ListTile(
//                   leading: new Icon(Icons.photo),
//                   title: new Text('Choose from gallery'),
//                   onTap: () {
//                     snapshot.addNewCustomerNotePhotoAction(1);
//                     snapshot.closeWindowAction();
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     } else {
//       ///For iOS
//       final action = CupertinoActionSheet(
//         actions: <Widget>[
//           CupertinoActionSheetAction(
//             child: Text("Click using Camera"),
//             isDefaultAction: true,
//             onPressed: () {
//               snapshot.addNewCustomerNotePhotoAction(0);
//               snapshot.closeWindowAction();
//             },
//           ),
//           CupertinoActionSheetAction(
//             child: Text("Choose from Gallery"),
//             isDefaultAction: true,
//             onPressed: () {
//               snapshot.addNewCustomerNotePhotoAction(1);
//               snapshot.closeWindowAction();
//             },
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           child: Text("Cancel"),
//           onPressed: () => snapshot.closeWindowAction(),
//         ),
//       );
//       showCupertinoModalPopup(context: context, builder: (context) => action);
//     }
//   }

//   ///To display the customer note image in full screen mode when it is tapped on!
//   void showImageInFullScreenMode(String imageUrl, _ViewModel snapshot) {
//     showGeneralDialog(
//       barrierColor: null,
//       barrierDismissible: false,
//       transitionDuration: const Duration(milliseconds: 150),
//       context: context,
//       pageBuilder: (context, _, __) => new Scaffold(
//         body: SafeArea(
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               CachedNetworkImage(
//                 height: double.infinity,
//                 width: double.infinity,
//                 imageUrl: imageUrl,
//                 fit: BoxFit.contain,
//                 placeholder: (context, url) => Center(
//                   child: SizedBox(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 10),
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.arrow_back,
//                     ),
//                     onPressed: () => snapshot.closeWindowAction(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ViewModel extends BaseModel<AppState> {
//   List<String> customerNoteImages;
//   LoadingStatusApp loadingStatusApp;
//   VoidCallback closeWindowAction;
//   Function(int) addNewCustomerNotePhotoAction;
//   Function(int) removeCustomerImageAction;

//   _ViewModel();

//   _ViewModel.build({
//     @required this.customerNoteImages,
//     @required this.closeWindowAction,
//     @required this.loadingStatusApp,
//     @required this.addNewCustomerNotePhotoAction,
//     @required this.removeCustomerImageAction,
//   }) : super(equals: [customerNoteImages, loadingStatusApp]);

//   @override
//   BaseModel fromStore() {
//     // TODO: implement fromStore
//     return _ViewModel.build(
//       loadingStatusApp: state.authState.loadingStatus,
//       customerNoteImages: state.cartState.customerNoteImages,
//       closeWindowAction: () => dispatch(NavigateAction.pop()),
//       addNewCustomerNotePhotoAction: (imageSource) =>
//           dispatch(PickImageAction(imageSource: imageSource)),
//       removeCustomerImageAction: (imageIndex) =>
//           dispatch(RemoveCustomerNoteImageAction(imageIndex: imageIndex)),
//     );
//   }
// }
