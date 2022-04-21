class ProductModel {
  String category;
  String imgUrl;
  String title;
  String subTitle;
  String price;
  String description;

  ProductModel({
    required this.category,
    required this.imgUrl,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.description,
  });

  factory ProductModel.fromJson(Map<dynamic, dynamic> map) {
    return ProductModel(
      category: map['category'],
      imgUrl: map['imgUrl'],
      title: map['title'],
      subTitle: map['subTitle'],
      price: map['price'],
      description: map['description'],
    );
  }

  toJson() {
    return {
      'category': category,
      'imgUrl': imgUrl,
      'title': title,
      'subTitle': subTitle,
      'price': price,
      'description': description,
    };
  }
}
