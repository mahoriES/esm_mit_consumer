import 'package:async_redux/async_redux.dart';
import 'package:eSamudaay/models/loading_status.dart';
import 'package:eSamudaay/modules/home/models/cluster.dart';
import 'package:eSamudaay/redux/states/app_state.dart';
import 'package:eSamudaay/utilities/colors.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:flutter/material.dart';
import 'package:eSamudaay/modules/circles/actions/circle_picker_actions.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CirclePicker extends StatefulWidget {
  @override
  _CirclePickerState createState() => _CirclePickerState();
}

class _CirclePickerState extends State<CirclePicker> {

  TextEditingController _clusterCodeTextEditingController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      model: _ViewModel(),
      onInit: (store) {
        store.dispatch(GetNearbyCirclesAction());
      },
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Circles', style: TextStyle(
              fontFamily: 'Arial',
              fontSize: fit.t(20),
              color: AppColors.blackTextColor,
            ),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.blackTextColor,),
                onPressed: ()=> Navigator.pop(context),),
          ),

          body: Material(
            child: SizedBox.expand(
              child: ModalProgressHUD(
                progressIndicator: Card(
                  child: Image.asset(
                    'assets/images/indicator.gif',
                    height: 74,
                  ),
                ),
                inAsyncCall: snapshot.loadingStatusApp == LoadingStatusApp.loading,
                child: Container(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(padding: EdgeInsets.only(top: 10,bottom: 10),
                        sliver: SliverList(delegate: SliverChildListDelegate(
                          <Widget> [
                            Padding(padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                              child: Text(
                                'You can manually add more circles to your '
                                    'account, if there are no circles nearby or'
                                    'you can also shop in other circles.',
                                style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: fit.t(14),
                                color: AppColors.greyishText
                              ), textAlign: TextAlign.center,),
                            ),
                            Padding(padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 10,
                            ),
                              child: TextField(
                                onSubmitted: (circleCode) {
                                  if (circleCode.length==0) return;
                                  snapshot.addCircleAction(
                                      circleCode.toUpperCase());
                                },
                                controller: _clusterCodeTextEditingController,
                                decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10.0),
                                      ),
                                    ),
                                    filled: true,
                                    hintStyle: new TextStyle(
                                        color: AppColors.greyishText,
                                        fontSize: fit.t(14),
                                        fontFamily: 'Arial'
                                    ),
                                    hintText: "Add circle using circle code...",
                                    fillColor: Colors.white70),
                              ),
                            ),
                          ],
                      ),),),
                      if (snapshot.nearbyClusters != null && snapshot.nearbyClusters.isNotEmpty)
                        buildNearbyCirclesList(snapshot),
                      if (snapshot.myClusters != null && snapshot.myClusters.isNotEmpty)
                        buildSavedCirclesList(snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSavedCirclesList(_ViewModel snapshot) {
    return SliverPadding(padding: EdgeInsets.only(
      top: 10,),
      sliver: SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) => index == 0 ?
            getClusterTypeTitle('My Saved Circles')
                : buildSavedCircleTile(
              circleCode: snapshot.myClusters[index-1].clusterCode,
              circleName: snapshot.myClusters[index-1].clusterName,
              snapshot: snapshot,
              circleId: snapshot.myClusters[index-1].clusterId,
        ),
        childCount: snapshot.myClusters.length+1
      ),),
    );
  }

  Widget getClusterTypeTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: 10,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.blackTextColor,
          fontSize: fit.t(20),
          fontFamily: 'Arial',
          fontWeight: FontWeight.w300
        ),
      ),
    );
  }

  Widget buildNearbyCirclesList(_ViewModel snapshot) {
    return SliverPadding(padding: EdgeInsets.only(
      top: 10,),
      sliver: SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) => index == 0 ?
              getClusterTypeTitle('My Nearby  Circles')
                  : buildNearbyCircleTile(
            circleCode: snapshot.nearbyClusters[index-1].clusterCode,
            circleName: snapshot.nearbyClusters[index-1].clusterName,
            snapshot: snapshot,
          ),
          childCount: snapshot.nearbyClusters.length+1
      ),),
    );
  }

  Widget buildSavedCircleTile({String circleName, String circleCode,
    _ViewModel snapshot, String circleId}) {

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        top: 10,
        bottom: 10,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.pureWhite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(flex:70, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(circleName,style: TextStyle(
                fontSize: fit.t(15),
                fontFamily: 'Arial',
                fontWeight: FontWeight.w400,
                color: AppColors.blackTextColor
              ),overflow: TextOverflow.ellipsis,),
              SizedBox(height: AppSizes.widgetPadding,),
              Text('Cluster Code: '+circleCode,style: TextStyle(
                  fontSize: fit.t(12),
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyishText
              ),overflow: TextOverflow.ellipsis),
            ],
          ),),
          Expanded(flex: 30, child: Align(alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                snapshot.removeCircleAction(circleCode, circleId);
              },
              child: Text('Remove', style: TextStyle(
                color: AppColors.iconColors,
                fontSize: fit.t(14),
                fontFamily: 'Arial'
              ),overflow: TextOverflow.ellipsis),
            ),
          ),),
        ],
      ),
    );

  }

  Widget buildNearbyCircleTile({String circleName, String circleCode,
    _ViewModel snapshot}) {

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.pureWhite,
      ),
      child: Row(
        children: [
          Expanded(flex: 20,child: SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(
              "assets/images/location2.png",
              color: AppColors.iconColors,
            ),
          ),),
          Expanded(flex:60, child: Column(
            children: [
              Text(circleName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fit.t(15),
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackTextColor,
              ),),
              SizedBox(height: AppSizes.widgetPadding,),
              Text("Cluster Code: "+circleCode,style: TextStyle(
                  fontSize: fit.t(12),
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyishText
              ),overflow: TextOverflow.ellipsis),
            ],
          ),),
          Expanded(flex: 20, child: Center(
            child: GestureDetector(
              onTap: () {
                snapshot.addCircleAction(circleCode);
              },
              child: Text('+ Add', style: TextStyle(
                  color: AppColors.green,
                  fontSize: fit.t(14),
                  fontFamily: 'Arial'
              ),overflow: TextOverflow.ellipsis),
            ),
          ),),
        ],
      ),
    );

  }

  Widget get noCirclesNearbyWidget {

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.green,
            size: fit.t(50),
          ),
          Padding(padding: EdgeInsets.only(
            top: AppSizes.widgetPadding,
            left: AppSizes.widgetPadding,
            right: AppSizes.widgetPadding,
            ),child: Text(
            'No circles found nearby! Please add circles manually',
            style: TextStyle(
            fontFamily: 'Avenir',
            fontSize: fit.t(40),
          ),
          ),),
        ],
      ),
    );

  }

}


class _ViewModel extends BaseModel<AppState> {

  LoadingStatusApp loadingStatusApp;
  List<Cluster> myClusters;
  List<Cluster> nearbyClusters;
  Function(String circleCode) addCircleAction;
  Function(String circleCode, String circleId) removeCircleAction;

  _ViewModel();

  _ViewModel.build({
    @required this.loadingStatusApp,
    @required this.myClusters,
    @required this.nearbyClusters,
    @required this.addCircleAction,
    @required this.removeCircleAction
  }) : super(equals: [
    loadingStatusApp,
    myClusters,
    nearbyClusters,
  ]);

  @override
  BaseModel fromStore() {

    return _ViewModel.build(
      loadingStatusApp: state.authState.loadingStatus,
      myClusters: state.authState.myClusters,
      nearbyClusters: state.authState.nearbyClusters,
      addCircleAction: (circleCode) {
        dispatch(AddCircleToProfileAction(circleCode: circleCode));
      },
      removeCircleAction: (circleCode, circleId) {
        dispatch(RemoveCircleFromProfileAction(
            circleCode: circleCode,
            circleId: circleId
        ));
    }
    );
  }

}
