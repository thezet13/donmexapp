class Address {
    int id;
    String country;
    String city;
    String address1;
    String address;
    String comment;
    String lat;
    String lng;
    String zipCode;
    int sortOrder;
  
    Address({
      required this.id,
      required this.country,
      required this.city,
      required this.address1,
      required this.address,
      required this.comment,
      required this.lat,
      required this.lng,
      required this.zipCode,
      required this.sortOrder,
    });
  
    factory Address.fromJson(Map<String, dynamic> json) {
      return Address(
        id: json['id'],
        country: json['country'],
        city: json['city'],
        address1: json['address1'],
        address: json['address2'],
        comment: json['comment'],
        lat: json['lat'],
        lng: json['lng'],
        zipCode: json['zip_code'],
        sortOrder: json['sort_order'],
      );
    }
  }
  
  class UserModel {
    String clientId;
    String firstName;
    String lastName;
    String patronymic;
    String phone;
    String phoneNumber;
    String email;
    String cardNumber;
    String clientSex;
    String country;
    String city;
    String comment;
    String address;
    List<Address> addresses;
  
    UserModel({
      required this.clientId,
      required this.firstName,
      required this.lastName,
      required this.patronymic,
      required this.phone,
      required this.phoneNumber,
      required this.email,
      required this.cardNumber,
      required this.clientSex,
      required this.country,
      required this.city,
      required this.comment,
      required this.address,
      required this.addresses,
    });
  
    factory UserModel.fromJson(Map<String, dynamic> json) {
      final response = json['response'][0];
      final addressesJson = response['addresses'] as List<dynamic>;
      final addresses = addressesJson.map((addr) => Address.fromJson(addr)).toList();
      
      return UserModel(
        clientId: response['client_id'],
        firstName: response['firstname'],
        lastName: response['lastname'],
        patronymic: response['patronymic'],
        phone: response['phone'],
        phoneNumber: response['phone_number'],
        email: response['email'],
        cardNumber: response['card_number'],
        clientSex: response['client_sex'],
        country: response['country'],
        city: response['city'],
        comment: response['comment'],
        address: response['address'],
        addresses: addresses,
      );
    }
  }