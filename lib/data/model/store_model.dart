class StoreResponse {
  final String message;
  final List<Store> stores;

  StoreResponse({required this.message, required this.stores});

  factory StoreResponse.fromJson(Map<String, dynamic> json) {
    return StoreResponse(
      message: json['message'] ?? '',
      stores: (json['stores'] as List)
          .map((store) => Store.fromJson(store))
          .toList(),
    );
  }
}

class Store {
  final int id;
  final String storeName;
  final String address;
  final List<Inventory> inventories;

  Store({
    required this.id,
    required this.storeName,
    required this.address,
    required this.inventories,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
      storeName: json['store_name'] ?? '',
      address: json['address'] ?? '',
      inventories: (json['inventories'] as List)
          .map((inventory) => Inventory.fromJson(inventory))
          .toList(),
    );
  }
}

class Inventory {
  // Define properties based on actual inventory structure
  Inventory();

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(); // Adjust with actual fields
  }
}
