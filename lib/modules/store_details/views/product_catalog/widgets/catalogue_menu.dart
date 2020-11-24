import 'package:eSamudaay/modules/home/models/category_response.dart';
import 'package:eSamudaay/themes/custom_theme.dart';
import 'package:flutter/material.dart';

class CatalogueMenuComponent extends StatelessWidget {
  final List<CategoriesNew> categories;
  const CatalogueMenuComponent({
    @required this.categories,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      indicatorColor: CustomTheme.of(context).colors.primaryColor,
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: CustomTheme.of(context).textStyles.cardTitle,
      unselectedLabelColor:
          CustomTheme.of(context).colors.textColor.withOpacity(0.4),
      labelColor: CustomTheme.of(context).colors.textColor,
      tabs: List.generate(
        categories.length + 1,
        (index) => Tab(
          child: FittedBox(
            child: Text(
              index == 0 ? "All" : categories[index - 1].categoryName,
            ),
          ),
        ),
      ),
    );
  }
}
