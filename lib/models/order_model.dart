class OrderModel {
  String? spotId;
  String? clientId;
  String? lastname;
  String? serviceMode;
  String? address;
  String? transactionId;
  String? process;
  List<Products>? products;

  OrderModel(
      {this.spotId, this.clientId, this.serviceMode, this.products, this.address, this.lastname});

  OrderModel.fromJson(Map<String, dynamic> json) {
    spotId = json['spot_id'];
    clientId = json['client_id'];
    serviceMode = json['service_mode'];
    lastname = json['last_name'];
    address = json['address'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spot_id'] = this.spotId;
    data['client_id'] = this.clientId;
    data['service_mode'] = this.serviceMode;
    data['last_name'] = this.lastname;
    data['address'] = this.address;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? productId;
  int? count;
  List<Modification>? modification;

  Products({this.productId, this.count, this.modification});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    count = json['count'];
    if (json['modification'] != null) {
      modification = <Modification>[];
      json['modification'].forEach((v) {
        modification!.add(new Modification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['count'] = this.count;
    if (this.modification != null) {
      data['modification'] = this.modification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modification {
  String? m;
  String? a;

  Modification({this.m, this.a});

  Modification.fromJson(Map<String, dynamic> json) {
    m = json['m'];
    a = json['a'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['m'] = this.m;
    data['a'] = this.a;
    return data;
  }
}
