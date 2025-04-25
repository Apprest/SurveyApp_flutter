class Product {
  final String itemName;
  final String image;
  // final String category;
  // final String description;
  // final int sort;
  // final int price;

  Product({required this.itemName, required this.image,});
    // this.price = 0,
    // this.category = '',
    // this.description = '',
    // this.sort = 0

  factory Product.fromJson(Map<String, dynamic> json) {
    // التحقق من وجود الحقول المطلوبة
    if (json['itemName'] == null || json['image'] == null) {
      throw FormatException('Missing required fields in product data');
    }

    return Product(
      itemName: json['itemName'] ?? 'No name',
      image: "https://560057.youcanlearnit.net/services/images/${json['image'] ?? ''}",
    );
  }
  // factory Product.fromJson(Map<String, dynamic> json){
  //   return Product(itemName: json['itemName'], image: json['image']);
  // }
  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'image': image,
    };
  }

}
