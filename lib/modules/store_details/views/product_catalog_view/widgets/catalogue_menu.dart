import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';

class CatalogueMenuComponent extends StatelessWidget {
  final List<CategoriesNew> categories;
  final TabController tabController;
  final Function(int) updateCategory;
  const CatalogueMenuComponent({
    @required this.categories,
    @required this.tabController,
    @required this.updateCategory,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.toWidth),
      child: TabBar(
        onTap: updateCategory,
        controller: tabController,
        isScrollable: true,
        indicatorColor: CustomTheme.of(context).colors.primaryColor,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: CustomTheme.of(context).textStyles.cardTitle,
        unselectedLabelColor:
            CustomTheme.of(context).colors.textColor.withOpacity(0.4),
        labelColor: CustomTheme.of(context).colors.textColor,
        tabs: List.generate(
          // The tabbar consists an extra tab called "All" at 0th index so length should be incremented by 1.
          categories.length + 1,
          (index) => Tab(
            child: FittedBox(
              child:
                  Text(index == 0 ? "All" : categories[index - 1].categoryName),
            ),
          ),
        ),
      ),
    );
  }
}
