class CommunityModel {
  final String code;
  final String name;
  final String idAdmin;

  CommunityModel({
    required this.code,
    required this.name,
    required this.idAdmin,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'idAdmin': idAdmin,
    };
  }
}
