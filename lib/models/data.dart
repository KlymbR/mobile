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
  String firstName, lastname, phone, licenceNbr, genre;
  DateTime birthday;

  DataUser()
      : birthday = new DateTime.now(),
        genre = "Monsieur",
        licenceNbr = "",
        lastname = "",
        phone = "",
        firstName = "";

  DataUser.init(this.firstName, this.lastname, this.phone,
      this.genre, this.licenceNbr, this.birthday);

  factory DataUser.fromWebJson(Map<String, dynamic> data) {
    print("data " + data.toString());
    return data == null
        ? null
        : new DataUser.init(data['firstname'], data['lastname'], data['phone'],
           data['genre'], data['licenceNbr'], new DateTime.fromMillisecondsSinceEpoch(
            data['birthday']['\$date']));
  }

  factory DataUser.fromJson(Map<String, dynamic> data) {
    print("data " + data.toString());
    return data == null
        ? null
        : new DataUser.init(data['firstname'], data['lastname'], data['phone'],
        data['genre'], data['licenceNbr'], DateTime.parse(
            data['birthday']));
  }

  String toString() => "User name $lastname de sex $genre";

  Map toJson() => {
        "firstname": firstName,
        "lastname": lastname,
        "phone": phone,
        "birthday": birthday.toString(),
        "genre": genre,
        "licenceNbr": licenceNbr
      };
}
