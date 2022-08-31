class Users {
  int Id = 0;
  String email = '';
  String pass = '';
  String role = "Юзер"; //  Админ
  String userFio = '';

  Users(this.Id, this.email, this.pass, this.role, this.userFio);
  Users.empty();

  Users.fromJson(Map<String, dynamic> json)
      : Id = json['Id'],
        email = json['email'],
        pass = json['pass'],
        role = json['role'],
        userFio = json['userFio'];

  Map<String, dynamic> toJson() => {
        'Id': Id,
        'email': email,
        'pass': pass,
        'role': role,
        'userFio': userFio
      };

  @override
  String toString() {
    return 'Id = $Id, email = $email, pass = $pass, role = $role, userFio = $userFio';
  }
}
