class Report {
  final int id;
  final String title;
  final String type;
  final String description;
  final String place;
  final String postalCode;
  final String names;
  final String lastName;
  final String phone;
  final String email;

  Report({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.place,
    required this.postalCode,
    required this.names,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      description: json['description'],
      place: json['place'],
      postalCode: json['postalCode'],
      names: json['names'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'place': place,
      'postalCode': postalCode,
      'names': names,
      'lastName': lastName,
      'phone': phone,
      'email': email,
    };
  }
}
