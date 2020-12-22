import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircleTileGridView extends StatelessWidget {
  final List<CircleTileType> tilesDataList;
  final Function(String, String) onDelete;
  final Function(String) onTap;

  const CircleTileGridView(
      {Key key,
      @required this.tilesDataList,
      this.onDelete,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 27.0,
          mainAxisSpacing: 18.0,
          childAspectRatio: 149.5 / 163.8,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return CircleTileWidget(
              imageUrl: tilesDataList[index].imageUrl,
              onTap: () {
                onTap(tilesDataList[index].circleCode);
              },
              isSelected: tilesDataList[index].isSelected,
              onDelete: onDelete != null
                  ? () {
                      onDelete(tilesDataList[index].circleCode,
                          tilesDataList[index].circleId);
                    }
                  : onDelete,
              circleName: tilesDataList[index].circleName,
              circleDescription: tilesDataList[index].circleDescription);
        },
        itemCount: tilesDataList.length,
      ),
    );
  }
}

class CircleTileType {
  final String imageUrl;
  final String circleName;
  final String circleDescription;
  final bool isSelected;
  final String circleCode;
  final String circleId;

  CircleTileType(
      {@required this.imageUrl,
      @required this.circleId,
      @required this.circleCode,
      @required this.circleName,
      @required this.circleDescription,
      @required this.isSelected});
}

class CircleTileWidget extends StatelessWidget {
  final String imageUrl;
  final String circleName;
  final String circleDescription;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isSelected;

  const CircleTileWidget(
      {Key key,
      @required this.imageUrl,
      @required this.onTap,
      @required this.isSelected,
      @required this.onDelete,
      @required this.circleName,
      @required this.circleDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double tileWidth = 149.5 / 375 * SizeConfig.screenWidth;
    final double tileHeight = 163.8 / 375 * SizeConfig.screenWidth;
    return SizedBox(
      width: tileWidth,
      height: tileHeight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: CustomTheme.of(context).colors.backgroundColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                    color: CustomTheme.of(context).colors.shadowColor16)
              ]),
          child: Column(
            children: [
              Expanded(
                flex: 65,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imageUrl ?? "",
                        placeholder: (context, url) =>
                            const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.image,
                            size: AppSizes.productItemIconSize,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 8, top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isSelected
                                ? Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: ShapeDecoration(
                                        color: CustomTheme.of(context)
                                            .colors
                                            .backgroundColor,
                                        shape: CircleBorder(),
                                        shadows: [
                                          BoxShadow(
                                              blurRadius: 3.0,
                                              offset: Offset(0, 3),
                                              color: CustomTheme.of(context)
                                                  .colors
                                                  .shadowColor16)
                                        ]),
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                    ),
                                  )
                                : Spacer(),
                            onDelete == null
                                ? Spacer()
                                : InkWell(
                                    onTap: onDelete,
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: ShapeDecoration(
                                          color: CustomTheme.of(context)
                                              .colors
                                              .backgroundColor,
                                          shape: CircleBorder(),
                                          shadows: [
                                            BoxShadow(
                                                blurRadius: 3.0,
                                                offset: Offset(0, 3),
                                                color: CustomTheme.of(context)
                                                    .colors
                                                    .shadowColor16)
                                          ]),
                                      child: Icon(
                                        Icons.delete,
                                        size: 16,
                                        color: CustomTheme.of(context)
                                            .colors
                                            .disabledAreaColor,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 5),
                  child: Column(
                    children: [
                      Text(
                        circleName,
                        maxLines: 1,
                        style: CustomTheme.of(context).textStyles.cardTitle,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        circleDescription,
                        maxLines: 1,
                        style: CustomTheme.of(context).textStyles.body1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecretCircleBottomSheet extends StatefulWidget {
  final Function(String) onAddCircle;

  const SecretCircleBottomSheet({Key key, this.onAddCircle}) : super(key: key);

  @override
  _SecretCircleBottomSheetState createState() =>
      _SecretCircleBottomSheetState();
}

class _SecretCircleBottomSheetState extends State<SecretCircleBottomSheet> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: CustomTheme.of(context).colors.backgroundColor),
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.widgetPadding, vertical: AppSizes.widgetPadding),
      child: Row(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: tr('circle.search'),
              hintStyle: CustomTheme.of(context)
                  .themeData
                  .textTheme
                  .subtitle1
                  .copyWith(
                      color: CustomTheme.of(context).colors.disabledAreaColor),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CustomTheme.of(context).colors.shadowColor16),
                borderRadius: BorderRadius.circular(5),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          InkWell(
            onTap: widget.onAddCircle(_textEditingController.text),
            child: Container(
              decoration: BoxDecoration(
                  color: CustomTheme.of(context).colors.disabledAreaColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4))),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: CustomTheme.of(context).colors.backgroundColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CircleInfoFooter extends StatefulWidget {
  final Function onTapCallBack;

  const CircleInfoFooter({@required this.onTapCallBack});

  @override
  _CircleInfoFooterState createState() => _CircleInfoFooterState();
}

class _CircleInfoFooterState extends State<CircleInfoFooter> {
  bool isAdvancedUser;
  int tapCount;

  @override
  void initState() {
    checkAdvancedUser();
    super.initState();
  }

  void checkAdvancedUser() {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          GestureDetector(
            onTap: secretCodeActionHandler,
            child: Text(
              'circle.branding',
              style: CustomTheme.of(context).textStyles.topTileTitle.copyWith(
                  color: CustomTheme.of(context).colors.disabledAreaColor),
            ).tr(),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'circle.info_1',
            style: CustomTheme.of(context).textStyles.sectionHeading1.copyWith(
                color: CustomTheme.of(context).colors.disabledAreaColor),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(
            height: 30,
          ),
          Text(
            'circle.info_2',
            style: CustomTheme.of(context).textStyles.sectionHeading1.copyWith(
                color: CustomTheme.of(context).colors.disabledAreaColor),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  void secretCodeActionHandler() async {
    if (isAdvancedUser) {
      widget.onTapCallBack();
    } else {
      tapCount++;
      if (tapCount % 3 == 0) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isAdvancedUser', true);
        isAdvancedUser = true;
        widget.onTapCallBack();
      }
    }
  }
}

class SuggestedNearbyCirclesView extends StatelessWidget {
  final List<CircleTileType> suggestedCirclesList;
  final bool isLocationDisabled;
  final Function(String) onSelectCircle;
  final VoidCallback onTapLocationAction;

  const SuggestedNearbyCirclesView(
      {Key key,
      this.suggestedCirclesList,
      this.onSelectCircle,
      this.onTapLocationAction,
      @required this.isLocationDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLocationDisabled && suggestedCirclesList.isEmpty)
      return const SizedBox.shrink();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: AppSizes.widgetPadding, left: 24),
            child: Text(
              'circle.suggested',
              style: CustomTheme.of(context).textStyles.sectionHeading2,
            ).tr(),
          ),
          if (isLocationDisabled)
            LocationDisabledView(onTapLocationAction: onTapLocationAction),
          if (suggestedCirclesList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CircleTileGridView(
                  tilesDataList: suggestedCirclesList, onTap: onSelectCircle),
            )
        ],
      ),
    );
  }
}

class SavedCirclesView extends StatelessWidget {
  final List<CircleTileType> savedCirclesList;
  final Function onTap;
  final Function onDelete;

  const SavedCirclesView(
      {Key key,
      @required this.savedCirclesList,
      @required this.onDelete,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (savedCirclesList.isEmpty) return SizedBox.shrink();
    debugPrint('Saved list ${savedCirclesList.toSet()}');
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              'circle.saved',
              style: CustomTheme.of(context).textStyles.sectionHeading2,
            ).tr(),
          ),
          CircleTileGridView(
              tilesDataList: savedCirclesList, onDelete: onDelete, onTap: onTap)
        ],
      ),
    );
  }
}

class LocationDisabledView extends StatelessWidget {
  final VoidCallback onTapLocationAction;

  const LocationDisabledView({Key key, @required this.onTapLocationAction})
      : assert(onTapLocationAction != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'circle.location',
              textAlign: TextAlign.center,
              style: CustomTheme.of(context)
                  .textStyles
                  .sectionHeading2
                  .copyWith(
                      color: CustomTheme.of(context).colors.disabledAreaColor),
            ).tr(),
          ),
          const SizedBox(
            height: AppSizes.widgetPadding,
          ),
          InkWell(
            onTap: onTapLocationAction,
            child: Container(
              padding:
                  EdgeInsets.symmetric(vertical: AppSizes.separatorPadding),
              width: 234 / 375 * SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                    width: 1.5,
                    color: CustomTheme.of(context).colors.primaryColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/location2.png',
                    color: CustomTheme.of(context).colors.primaryColor,
                  ),
                  const SizedBox(
                    width: AppSizes.separatorPadding / 2,
                  ),
                  Text(
                    'circle.turn_on',
                    style: CustomTheme.of(context).textStyles.sectionHeading1,
                  ).tr(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
