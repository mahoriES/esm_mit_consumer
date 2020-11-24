import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class SubCatergoriesTabbar extends StatelessWidget {
  final List<CategoriesNew> subCategories;
  const SubCatergoriesTabbar({
    @required this.subCategories,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TabBar(
        isScrollable: true,
        labelPadding: EdgeInsets.zero,
        indicatorColor: CustomTheme.of(context).colors.primaryColor,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: CustomTheme.of(context).textStyles.cardTitle,
        unselectedLabelColor:
            CustomTheme.of(context).colors.textColor.withOpacity(0.4),
        labelColor: CustomTheme.of(context).colors.textColor,
        tabs: List.generate(
          subCategories.length + 1,
          (index) => Container(
            width: SizeConfig.screenWidth / 5,
            child: Tab(
              child: FittedBox(
                child: Text(
                  index == 0 ? "All" : subCategories[index - 1].categoryName,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
