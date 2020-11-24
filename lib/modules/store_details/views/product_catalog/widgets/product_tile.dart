import 'package:eSamudaay/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductTile extends StatelessWidget {
  final int index;
  final int length;
  final Function loadMore;
  const ProductTile(this.length, this.index, this.loadMore);
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: new UniqueKey(),
      onVisibilityChanged: (info) {
        print("in view $index");
        if (index == length - 3) {
          loadMore();
        }
      },
      child: Container(
        height: 80.toHeight,
        width: double.infinity,
        child: Center(
          child: Text(
            "product name $index",
            // snapshot.products[productIndex].productName,
          ),
        ),
      ),
    );
  }
}
