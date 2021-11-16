class UserModel {
  LoginDataModel? data;

  UserModel.fromJson(Map<String, dynamic> json) {
    data = LoginDataModel.fromJson(json['LogIN'][0]);
  }
}

class LoginDataModel {
  String? activationValid;
  String? name;
  String? userId;
  String profileImage = "";
  String coverImage = "";

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    activationValid = json['activationValid'];
    name = json['Name'];
    userId = json['ID'];
  }
}
