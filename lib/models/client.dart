class Client {
  final int id;
  final String fullName;
  final String username;
  final int age;
  final String gender;
  final String? accessToken;

  Client({
    required this.id,
    required this.fullName,
    required this.username,
    required this.age,
    required this.gender,
    this.accessToken,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      age: json['age'],
      gender: json['gender'],
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'age': age,
      'gender': gender,
      'access_token': accessToken,
    };
  }
}