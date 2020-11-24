import 'package:eSamudaay/modules/store_details/models/catalog_search_models.dart';
import 'package:flutter/material.dart';

//TODO: Work in progress will require changes from another PR to get this done

class HighlightCatalogItems extends StatelessWidget {
  final List<Product> productList;
  final Function onTapActionButton;
  final String actionButtonTitle;

  const HighlightCatalogItems(
      {@required this.productList,
      @required this.actionButtonTitle,
      @required this.onTapActionButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(actionButtonTitle),
      ],),
    );
  }
}
