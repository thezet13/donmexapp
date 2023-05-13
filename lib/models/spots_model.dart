class Spot {
  final String? spot_id;
  final String? spot_name;
  final String? address;

  Spot({required this.spot_id, required this.spot_name, required this.address});

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      spot_id: json['spot_id'].toString(),
      spot_name: json['name'],
      address: json['address'],
    );
  }
}
