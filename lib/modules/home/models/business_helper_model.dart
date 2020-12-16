class HighlightedItemsType {
  final String itemName;
  final String itemQuantityOrServingSize;
  final String itemPriceWithoutCurrencyPrefix;
  final String itemImageUrl;

  HighlightedItemsType(
      {this.itemName,
      this.itemQuantityOrServingSize,
      this.itemPriceWithoutCurrencyPrefix,
      this.itemImageUrl});
}
