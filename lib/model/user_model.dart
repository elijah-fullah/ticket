class UserModel {
  String? id;
  static String userId = " ";
  String? firstName;
  String? lastName;
  String? role;
  String? phone;
  String? email;
  String? password;
  String? status;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.phone,
    this.email,
    this.password,
    this.status
  });

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['code'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    phone = json['contact'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
  }
}