class SignUpBody{
  late String client_name;
  late String phone;
  late String clientgroupsid;
  late String client_id;
  late String password;

  SignUpBody({
    required this.client_name,
    required this.phone,
    required this.clientgroupsid,
    required this.client_id,
    required this.password,

  });

  SignUpBody.fromJson(Map<String, dynamic> json) {
    client_name = json['client_name'];
    phone = json['phone'];
    client_id = json['client_id'];
    password = json['comment'];
   }

  Map<String, dynamic> toJson (){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["client_name"] = this.client_name;
    data["phone"] = this.phone; 
    data["client_groups_id_client"] = this.clientgroupsid;
    data["client_id"] = this.client_id;
    data["comment"] = this.password;
    print(data);
    return data;
  }

}