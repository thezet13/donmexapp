class Addresses {
    late int? _id;
    late String? _latitude;
    late String? _longitude;
  
  Addresses({
    id,
    latitude,
    longitude,
  }){
    _id=id;
    _latitude=latitude;
    _longitude=longitude;
}
    int? get id=>_id;
    String? get latitude=>_latitude;
    String? get longitude=>_longitude;
  
    Addresses.fromJson(Map<String, dynamic> json) {
        _id = json['id']??'';
        _latitude = json['lat']??'';
        _longitude = json['lng']??'';
    }
    
  
   Map<String, dynamic> toJson(){
    final Map<String, dynamic> data= Map<String, dynamic>();
       data['id']=this._id;
       data['lat']=this._latitude;
       data['lng']=this._longitude;
       print('printing ${data}');
       return data;
  }
}