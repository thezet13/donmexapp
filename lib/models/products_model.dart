class Products {
  late List<ProductsModel> _products;
  List<ProductsModel> get products => _products;

  Products({required products}) {
    this._products = products;
  }

  Products.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      _products = <ProductsModel>[];
      json['response'].forEach((v) {
        _products.add(ProductsModel.fromJson(v));
      });
    }
  }
}

class ProductsModel {
  int? productId;
  String? categoryName;
  String? menuCategoryId;
  String? photoOrigin;
  Price? price;
  String? productName;
  String? type;
  List<GroupModifications>? groupModifications;
  String? productProductionDescription;
  List<Ingredients>? ingredients;

  ProductsModel(
      {this.productId,
      this.categoryName,
      this.menuCategoryId,
      this.photoOrigin,
      this.price,
      this.productName,
      this.type,
      this.groupModifications,
      this.productProductionDescription,
      this.ingredients});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    menuCategoryId = json['menu_category_id'];
    photoOrigin = json['photo_origin'];
    price = json['price'] != null ? new Price.fromJson(json['price']) : null;
    productId = int.parse(json['product_id']);
    productName = json['product_name'];
    type = json['type'];
    if (json['group_modifications'] != null) {
      groupModifications = <GroupModifications>[];
      json['group_modifications'].forEach((v) {
        groupModifications!.add(new GroupModifications.fromJson(v));
      });
    }
    productProductionDescription = json['product_production_description'];
    if (json['ingredients'] != null) {
      ingredients = <Ingredients>[];
      json['ingredients'].forEach((v) {
        ingredients!.add(new Ingredients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": this.productId,
      "product_name": this.productName,
      "price": this.price,
      "photo_origin": this.photoOrigin,
      "type": this.type,
      "menu_category_id": this.menuCategoryId,
    };
  }
}

class Price {
  String? s1;

  Price({this.s1});

  Price.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    return data;
  }
}

class GroupModifications {
  int? dishModificationGroupId;
  String? name;
  int? numMin;
  int? numMax;
  int? type;
  int? isDeleted;
  List<Modifications>? modifications;

  GroupModifications(
      {this.dishModificationGroupId,
      this.name,
      this.numMin,
      this.numMax,
      this.type,
      this.isDeleted,
      this.modifications});

  GroupModifications.fromJson(Map<String, dynamic> json) {
    dishModificationGroupId = json['dish_modification_group_id'];
    name = json['name'];
    numMin = json['num_min'];
    numMax = json['num_max'];
    type = json['type'];
    isDeleted = json['is_deleted'];
    if (json['modifications'] != null) {
      modifications = <Modifications>[];
      json['modifications'].forEach((v) {
        modifications!.add(new Modifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_modification_group_id'] = this.dishModificationGroupId;
    data['name'] = this.name;
    data['num_min'] = this.numMin;
    data['num_max'] = this.numMax;
    data['type'] = this.type;
    data['is_deleted'] = this.isDeleted;
    if (this.modifications != null) {
      data['modifications'] = this.modifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Modifications {
  int? dishModificationId;
  String? name;
  int? ingredientId;
  int? type;
  double? price;
  String? photoOrig;
  String? lastModifiedTime;

  Modifications({
    this.dishModificationId,
    this.name,
    this.ingredientId,
    this.type,
    this.price,
    this.photoOrig,
    this.lastModifiedTime,
    // this.isChecked = false
  });

  Modifications.fromJson(Map<String, dynamic> json) {
    dishModificationId = json['dish_modification_id'];
    name = json['name'];
    ingredientId = json['ingredient_id'];
    type = json['type'];
    price = json['price']?.toDouble();
    photoOrig = json['photo_orig'];
    lastModifiedTime = json['last_modified_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_modification_id'] = this.dishModificationId;
    data['name'] = this.name;
    data['ingredient_id'] = this.ingredientId;
    data['type'] = this.type;
    data['price'] = this.price;
    data['photo_orig'] = this.photoOrig;
    data['last_modified_time'] = this.lastModifiedTime;
    return data;
  }
}

class Ingredients {
  String? ingredientId;
  String? ingredientName;

  Ingredients({
    this.ingredientId,
    this.ingredientName,
  });

  Ingredients.fromJson(Map<String, dynamic> json) {
    ingredientId = json['ingredient_id'];
    ingredientName = json['ingredient_name'];
  }
}
