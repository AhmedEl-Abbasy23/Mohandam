class CartModel {
  late String title, productId;
  late int quantity, price;
  late List images;

  CartModel({
    required this.title,
    required this.images,
    required this.price,
    required this.productId,
    this.quantity = 1,
  });

  factory CartModel.fromJson(Map<dynamic, dynamic> map) {
    return CartModel(
      productId: map['productId'],
      title: map['title'],
      images: map['images'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'images': images,
      'price': price,
      'productId': productId,
      'quantity': quantity,
    };
  }
}
