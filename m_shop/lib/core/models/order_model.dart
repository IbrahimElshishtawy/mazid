class OrderModel {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final DateTime orderDate;
  final String status;

  OrderModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.orderDate,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'].toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }
}
