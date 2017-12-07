class DataImplement {
  DataImplement.init();

  DataImplement();

  String toString() => "";

  Map toJson() => {};

  factory DataImplement.fromJson(Map<String, dynamic> data) {
    return new DataImplement();
  }
}

class DataUser implements DataImplement {
  String firstName, name, phone, licenceNbr, phoneNumber, sex;
  DateTime birthday;

  DataUser(): birthday = new DateTime.now(), sex = "Monsieur";

  DataUser.init(this.firstName, this.name, this.phone, this.birthday, this.sex,
      this.licenceNbr);

  factory DataUser.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new DataUser.init(data['firstname'], data['name'], data['phone'],
            data['birthday'], data['sex'], data['licenceNbr']);
  }

  String toString() =>
      "User name $name de sex $sex";

  Map toJson() => {
        "firstname": firstName,
        "name": name,
        "phone": phone,
        "birthday": birthday.toString(),
        "sex": sex,
        "licenceNbr": licenceNbr
      };
}
