class UserModel
{
  String displayName;
  String email;
  String phoneNumber;
  int canAccess;
  UserModel({this.displayName,this.email,this.phoneNumber,this.canAccess});
  factory UserModel.fromJson(Map<String, dynamic> json1) {
    return UserModel(
        displayName: json1['DisplayName'],
        email: json1['Email'],
        phoneNumber: json1['PhoneNumber'],
        canAccess: json1['CanAccess']
    );
  }
  Map<String,dynamic> toJson() =>
      {
        "DisplayName":this.displayName,
        "Email":this.email,
        "PhoneNumber":this.phoneNumber,
        "CanAccess":this.canAccess,
      };
}