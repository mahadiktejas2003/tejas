class User {
  late String _username;

  late String _password;

  //add late here to indicate that they will be initialized later, either through the constructor or other means.
  User(this._username, this._password);

  User.map(dynamic obj) {
    _username = obj['Username'];
    _password = obj['password'];
  }
  String get username => _username;
  String get password => _password;
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;
    return map;
  }
}
