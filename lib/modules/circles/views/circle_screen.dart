import 'package:cached_network_image/cached_network_image.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:eSamudaay/utilities/widget_sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleTileGridView extends StatelessWidget {
  final List<CircleTileType> tilesDataList;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const CircleTileGridView(
      {Key key,
      @required this.tilesDataList,
      @required this.onDelete,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: false,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 27.0,
        mainAxisSpacing: 18.0,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return CircleTileWidget(
            imageUrl: tilesDataList[index].imageUrl,
            onTap: null,
            isSelected: false,
            onDelete: null,
            circleName: tilesDataList[index].circleName,
            circleDescription: tilesDataList[index].circleDescription);
      },
      itemCount: tilesDataList.length,
    );
  }
}

class CircleTileType {
  final String imageUrl;
  final String circleName;
  final String circleDescription;
  final bool isSelected;

  CircleTileType(
      this.imageUrl, this.circleName, this.circleDescription, this.isSelected);
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
    final tileWidth = 149.5 / 375 * SizeConfig.screenWidth;

    return SizedBox(
      width: tileWidth,
      child: AspectRatio(
        aspectRatio: 149.5 / 163.8,
        child: Container(
          decoration: BoxDecoration(
            color: CustomTheme.of(context).colors.backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
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
                        padding: EdgeInsets.only(left: 12, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isSelected
                                ? Container(
                                    padding: EdgeInsets.all(4),
                                    decoration:
                                        ShapeDecoration(shape: CircleBorder()),
                                    child: Icon(
                                      Icons.check,
                                      color: CustomTheme.of(context)
                                          .colors
                                          .primaryColor,
                                    ),
                                  )
                                : Spacer(),
                            InkWell(
                              onTap: onDelete,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration:
                                    ShapeDecoration(shape: CircleBorder()),
                                child: Icon(
                                  Icons.delete,
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
                  child: Column(
                    children: [
                      Text(
                        circleName,
                        maxLines: 1,
                        style: CustomTheme.of(context).textStyles.cardTitle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        circleDescription,
                        maxLines: 1,
                        style: CustomTheme.of(context).textStyles.body1,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class CircleInfoFooter extends StatefulWidget {
  @override
  _CircleInfoFooterState createState() => _CircleInfoFooterState();
}

class _CircleInfoFooterState extends State<CircleInfoFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'circle.branding',
          ).tr(),
          Text('circle.info_1').tr(),
          Text('circle.info_2').tr(),
        ],
      ),
    );
  }
}

class SuggestedCirclesView extends StatelessWidget {
  final List<CircleTileType> suggestedCirclesList;
  final bool isLocationDisabled;
  final VoidCallback onTapLocationAction;

  const SuggestedCirclesView(
      {Key key,
      this.suggestedCirclesList,
      this.onTapLocationAction,
      @required this.isLocationDisabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'circle.suggested',
            style: CustomTheme.of(context).textStyles.sectionHeading2,
          ).tr(),
          if (isLocationDisabled)
            LocationDisabledView(onTapLocationAction: () {
              onTapLocationAction();
            }),
        ],
      ),
    );
  }
}

class SavedCirclesView extends StatelessWidget {
  final List<CircleTileType> savedCirclesList;

  const SavedCirclesView({Key key, @required this.savedCirclesList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'circle.saved',
            style: CustomTheme.of(context).textStyles.sectionHeading2,
          ).tr(),
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
          Text(
            'circle.location',
            style: CustomTheme.of(context).textStyles.sectionHeading2,
          ).tr(),
          const SizedBox(
            height: AppSizes.widgetPadding,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                  color: CustomTheme.of(context).colors.primaryColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: CustomTheme.of(context).colors.primaryColor,
                ),
                const SizedBox(
                  width: AppSizes.separatorPadding,
                ),
                Text(
                  'circle.turn_on',
                  style: CustomTheme.of(context).textStyles.sectionHeading1,
                ).tr(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
