class CartModel {
  late String title, image, price, productId;
  late int quantity;

  CartModel({
    required this.title,
    required this.image,
    required this.price,
    required this.productId,
    this.quantity = 1,
  });

  CartModel.fromJson(Map<dynamic, dynamic> map) {
    title = map['title'];
    image = map['image'];
    price = map['price'];
    productId = map['productId'];
    quantity = map['quantity'];
  }

  toJson() {
    return {
      'title': title,
      'image': image,
      'price': price,
      'productId': productId,
      'quantity': quantity,
    };
  }
}
