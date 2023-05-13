import 'package:donmexapp/models/products_model.dart';

class CartModel {
  int? uniqueKey;
  int? productId;
  String? productName;
  Price? price;
  String? photoOrigin;
  int? quantity;
  bool? isExist;
  String? time;
  ProductsModel? product;
  List<Map<String, String>>? modifications;

  CartModel({
    this.uniqueKey,
    this.productId,
    this.productName,
    this.price,
    this.photoOrigin,
    this.quantity,
    this.isExist,
    this.time,
    this.product,
    this.modifications,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    productId = int.parse(json['product_id']);
    productName = json['product_name'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    //price = Price.fromJson(json['price']);
    photoOrigin = json['photo_origin'];
    quantity = json['quantity'];
    isExist = json['isExist'];
    time = json['time'];
    product = ProductsModel.fromJson(json['product']);
    modifications = json['modifications'] != null
        ? List<Map<String, String>>.from(
            json['modifications'].map((x) => Map<String, String>.from(x)))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "product_id": this.productId,
      "product_name": this.productName,
      "price": this.price,
      "photo_origin": this.photoOrigin,
      "quantity": this.quantity,
      "isExist": this.isExist,
      "time": this.time,
      "product": this.product!.toJson(),
    };
    if (modifications != null) {
      data["modifications"] =
          List<dynamic>.from(modifications!.map((x) => Map<String, String>.from(x)));
    }
    return data;
  }
}
