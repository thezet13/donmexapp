class UserModel {
  String id;
  String phone;
  String firstname;
  String lastname;
  String email;
  String addressId;
  String address;
  String orderCount;

  UserModel({
    required this.id,
    required this.phone,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.addressId,
    required this.address,
    required this.orderCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['response'][0]['client_id'],
      phone: json['response'][0]['phone'],
      firstname: json['response'][0]['firstname'],
      lastname: json['response'][0]['lastname'],
      email: json['response'][0]['email'],
      addressId: json['response'][0]['addresses'][0]['id'].toString(),
      address: json['response'][0]['address'],
      orderCount: json['response'][0]['ewallet'],
    );
  }
}
