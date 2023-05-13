import 'package:donmexapp/models/address_model.dart';

class OrderModel {
  late int incomingOrderId;
  late int clientId;
  int? spotId;
  int? status;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? sex;
  String? birthday;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? transactionId;
  int? serviceMode;
  double? deliveryPrice;
  int? fiscalSpreading;
  String? fiscalMethod;
  String? deliveryTime;
  List<Products>? products;
  String? addressId;
  AddressModel? deliveryAddress;

  OrderModel({
    required this.incomingOrderId,
    required this.clientId,
    this.spotId,
    this.status,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.sex,
    this.birthday,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.transactionId,
    this.serviceMode,
    this.deliveryPrice,
    this.fiscalSpreading,
    this.fiscalMethod,
    this.deliveryTime,
    this.products,
    this.addressId,
    this.deliveryAddress,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    incomingOrderId = json['incoming_order_id'];
    spotId = json['spot_id'];
    status = json['status'];
    clientId = json['client_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    sex = json['sex'];
    birthday = json['birthday'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    transactionId = json['transaction_id'];
    serviceMode = json['service_mode'];
    deliveryPrice = json['delivery_price'];
    fiscalSpreading = json['fiscal_spreading'];
    fiscalMethod = json['fiscal_method'];
    deliveryTime = json['delivery_time'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
      addressId = json['id'];
      deliveryAddress =
          json['address1'] != null ? new AddressModel.fromJson(json['address1']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['incoming_order_id'] = this.incomingOrderId;
    data['spot_id'] = this.spotId;
    data['status'] = this.status;
    data['client_id'] = this.clientId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['sex'] = this.sex;
    data['birthday'] = this.birthday;

    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['transaction_id'] = this.transactionId;
    data['service_mode'] = this.serviceMode;
    data['delivery_price'] = this.deliveryPrice;
    data['fiscal_spreading'] = this.fiscalSpreading;
    data['fiscal_method'] = this.fiscalMethod;
    data['delivery_time'] = this.deliveryTime;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    ;
    data['id'] = this.addressId;
    if (this.deliveryAddress != null) {
      data['address1'] = this.deliveryAddress!.toJson();
    }
    return data;
  }
}

class Products {
  int? ioProductId;
  int? productId;
  int? modificatorId;
  int? incomingOrderId;
  int? count;
  String? createdAt;

  Products(
      {this.ioProductId,
      this.productId,
      this.modificatorId,
      this.incomingOrderId,
      this.count,
      this.createdAt});

  Products.fromJson(Map<String, dynamic> json) {
    ioProductId = json['io_product_id'];
    productId = json['product_id'];
    modificatorId = json['modificator_id'];
    incomingOrderId = json['incoming_order_id'];
    count = json['count'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['io_product_id'] = this.ioProductId;
    data['product_id'] = this.productId;
    data['modificator_id'] = this.modificatorId;
    data['incoming_order_id'] = this.incomingOrderId;
    data['count'] = this.count;
    data['created_at'] = this.createdAt;
    return data;
  }
}
