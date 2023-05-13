class Clients {
  late List<ClientsModel> _clients;
  List<ClientsModel> get clients=> _clients;

  Clients({required clients}){
    this._clients = clients;
  }

  Clients.fromJson(Map<String, dynamic> json) {
    if (json['response'] != null) {
      _clients = <ClientsModel>[];
      json['response'].forEach((v) {
        _clients.add(new ClientsModel.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   if (this.response != null) {
  //     data['response'] = this.response!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class ClientsModel {
  String? clientId;
  String? firstname;
  String? lastname;
  String? patronymic;
  String? discountPer;
  String? bonus;
  String? totalPayedSum;
  String? dateActivale;
  String? phone;
  String? phoneNumber;
  String? email;
  String? birthday;
  String? cardNumber;
  String? clientSex;
  String? country;
  String? city;
  String? password;
  String? address;
  String? clientGroupsId;
  String? clientGroupsName;
  String? clientGroupsDiscount;
  String? loyaltyType;
  String? birthdayBonus;
  String? ewallet;
  List<Addresses>? addresses;
  String? delete;

  ClientsModel(
      {this.clientId,
      this.firstname,
      this.lastname,
      this.patronymic,
      this.discountPer,
      this.bonus,
      this.totalPayedSum,
      this.dateActivale,
      this.phone,
      this.phoneNumber,
      this.email,
      this.birthday,
      this.cardNumber,
      this.clientSex,
      this.country,
      this.city,
      this.password,
      this.address,
      this.clientGroupsId,
      this.clientGroupsName,
      this.clientGroupsDiscount,
      this.loyaltyType,
      this.birthdayBonus,
      this.ewallet,
      this.addresses,
      this.delete});

  ClientsModel.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    patronymic = json['patronymic'];
    discountPer = json['discount_per'];
    bonus = json['bonus'];
    totalPayedSum = json['total_payed_sum'];
    dateActivale = json['date_activale'];
    phone = json['phone'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    birthday = json['birthday'];
    cardNumber = json['card_number'];
    clientSex = json['client_sex'];
    country = json['country'];
    city = json['city'];
    password = json['comment'];
    address = json['address'];
    clientGroupsId = json['client_groups_id'];
    clientGroupsName = json['client_groups_name'];
    clientGroupsDiscount = json['client_groups_discount'];
    loyaltyType = json['loyalty_type'];
    birthdayBonus = json['birthday_bonus'];
    ewallet = json['ewallet'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
    delete = json['delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['patronymic'] = this.patronymic;
    data['discount_per'] = this.discountPer;
    data['bonus'] = this.bonus;
    data['total_payed_sum'] = this.totalPayedSum;
    data['date_activale'] = this.dateActivale;
    data['phone'] = this.phone;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    data['card_number'] = this.cardNumber;
    data['client_sex'] = this.clientSex;
    data['country'] = this.country;
    data['city'] = this.city;
    data['comment'] = this.password;
    data['address'] = this.address;
    data['client_groups_id'] = this.clientGroupsId;
    data['client_groups_name'] = this.clientGroupsName;
    data['client_groups_discount'] = this.clientGroupsDiscount;
    data['loyalty_type'] = this.loyaltyType;
    data['birthday_bonus'] = this.birthdayBonus;
    data['ewallet'] = this.ewallet;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    data['delete'] = this.delete;
    return data;
  }
}

class Addresses {
  int? id;
  int? deliveryZoneId;
  String? country;
  String? city;
  String? address1;
  String? address2;
  String? comment;
  String? lat;
  String? lng;
  String? zipCode;
  int? sortOrder;

  Addresses(
      {this.id,
      this.deliveryZoneId,
      this.country,
      this.city,
      this.address1,
      this.address2,
      this.comment,
      this.lat,
      this.lng,
      this.zipCode,
      this.sortOrder});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryZoneId = json['delivery_zone_id'];
    country = json['country'];
    city = json['city'];
    address1 = json['address1'];
    address2 = json['address2'];
    comment = json['comment'];
    lat = json['lat'];
    lng = json['lng'];
    zipCode = json['zip_code'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['delivery_zone_id'] = this.deliveryZoneId;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['comment'] = this.comment;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['zip_code'] = this.zipCode;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}