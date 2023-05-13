class AddressModel {
    late String _clientId;
    late int _addressId;
    late String _address;
    late String _addressType;
    late String _latitude;
    late String _longitude;

  AddressModel({
    clientId,
    addressId,
    addressType,
    address,
    latitude,
    longitude,
  }){
    _clientId=clientId;
    _addressId=addressId;
    _addressType=addressType;
    _address=address;
    _latitude=latitude;
    _longitude=longitude;
}
    String get clientId=>_clientId;
    int get addressId=>_addressId;
    String get address=>_address;
    String get addressType=>_addressType;
    String get latitude=>_latitude;
    String get longitude=>_longitude;
  
  // AddressModel.fromJson(Map<String, dynamic> json){
  //   _clientId=json['client_id'].toString();
  //   _addressId=json['id'];
  //   _address=json['address1'];
  //   _addressType=json['comment'];
  //   _latitude=json['lat'];
  //   _longitude=json['lng'];
  // }


  AddressModel.fromJson(Map<String, dynamic> json){
    _clientId = json['client_id'].toString();
    _addressId = json['id'];
    _addressType = json['comment'];
    _address = json['address1'];
    _latitude = json['lat'];
    _longitude = json['lng'];
  }

 Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'client_id': clientId,
      'addresses': [
        {
          'id' : addressId,
          'comment': addressType,
          'address1': address,
          'lat': latitude,
          'lng': longitude,
        }
      ]
         };     return data;
 }


}
