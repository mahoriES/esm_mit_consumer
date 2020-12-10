import 'dart:io';
import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/modules/Profile/views/widgets/detail_tile.dart';
import 'package:eSamudaay/modules/Profile/views/widgets/image_view.dart';
import 'package:eSamudaay/presentations/loading_indicator.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/Profile/action/profile_update_action.dart';
import 'package:eSamudaay/modules/Profile/model/profile_update_model.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, _ViewModel>(
        model: _ViewModel(),
        builder: (context, snapshot) {
          return ModalProgressHUD(
            progressIndicator: Card(
              child: LoadingIndicator(),
            ),
            inAsyncCall: snapshot.loadingStatus == LoadingStatusApp.loading,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: true,
              ),
              body: Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 40.toWidth),
                child: SingleChildScrollView(
                  child: AnimationLimiter(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 375),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset:
                              MediaQuery.of(context).size.width / 2,
                          child: FadeInAnimation(child: widget),
                        ),
                        children: <Widget>[
                          SizedBox(height: 60.toHeight),
                          ProfileImageView(
                            imageurl: snapshot.userPhotoUrl,
                            updateImage: snapshot.profileUpdate,
                          ),
                          SizedBox(height: 65.toHeight),
                          DetailsTile(
                            data: snapshot.userName,
                            style:
                                CustomTheme.of(context).textStyles.topTileTitle,
                          ),
                          SizedBox(height: 12.toHeight),
                          DetailsTile(
                            data: snapshot.userPhone,
                            style: CustomTheme.of(context)
                                .textStyles
                                .sectionHeading2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel extends BaseModel<AppState> {
  _ViewModel();
  Data user;
  LoadingStatusApp loadingStatus;
  Function(File image) profileUpdate;

  _ViewModel.build({
    this.profileUpdate,
    this.loadingStatus,
    this.user,
  }) : super(equals: [loadingStatus, user]);

  @override
  BaseModel fromStore() {
    return _ViewModel.build(
      user: state.authState.user,
      loadingStatus: state.authState.loadingStatus,
      profileUpdate: (image) {
        if (image != null) {
          dispatch(UploadImageAction(imageFile: image));
        }
      },
    );
  }

  String get userName => user?.profileName ?? "";
  String get userPhone => user?.userProfile?.phone ?? "";
  String get userPhotoUrl => user?.profilePic?.photoUrl ?? "";
}
