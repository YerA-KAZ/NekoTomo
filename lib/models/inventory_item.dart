class InventoryItem {
  final int id;
  final String itemType;
  final String itemName;
  final int quantity;

  InventoryItem({
    required this.id,
    required this.itemType,
    required this.itemName,
    required this.quantity,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] ?? 0,
      itemType: json['itemType'] ?? json['item_type'] ?? 'food',
      itemName: json['itemName'] ?? json['item_name'] ?? 'Onigiri',
      quantity: json['quantity'] ?? 0,
    );
  }
}
