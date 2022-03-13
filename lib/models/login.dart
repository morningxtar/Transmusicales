class Login{
  String password;
  String email;
  String pseudo;

  Login({
    this.password = '',
    this.email = '',
    this.pseudo = '',
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      password: json['password'],
      email: json['email'],
      pseudo: json['pseudo'],
    );
  }

  @override
  String toString() {
    return 'email: ' + email + ' | password: ' + password;
  }
}