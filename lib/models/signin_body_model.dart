class SignInBody{
  late String phone;
  late String? client_name;
  late String? clientgroupsid;
  late String? client_id;
  late int? error;

  SignInBody({
    required this.phone,
    this.client_name,
    this.clientgroupsid,
    this.client_id,
    this.error

  });

  SignInBody.fromJson(Map<String, dynamic> json) {
    client_name = json['client_name'];
    phone = json['phone'];
    client_id = json['client_id'];
    error = json['error'];
   }

  // Map<String, dynamic> toJson (){
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data["client_name"] = this.client_name;
  //   data["phone"] = this.phone; 
  //   data["client_groups_id_client"] = this.clientgroupsid;
  //   data["client_id"] = this.client_id;
  //   return data;
  // }

}