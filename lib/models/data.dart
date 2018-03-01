class DataImplement {
  DataImplement.init();

  DataImplement();

  String toString();

  Map toJson() => {};

  factory DataImplement.fromJson(Map<String, dynamic> data) {
    return new DataImplement();
  }
}

class Licences implements DataImplement {
  String clubname, clubnb, fednb, status;
  DateTime enddate;

  Licences()
      : clubname = "",
        clubnb = "",
        fednb = "",
        status = "",
        enddate = new DateTime.now();

  Licences.init(
      this.clubname, this.clubnb, this.fednb, this.status, this.enddate);

  factory Licences.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new Licences.init(data["clubname"], data["clubnb"], data["fednb"],
            data["status"], DateTime.parse(data["enddate"]));
  }

  factory Licences.fromWebJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new Licences.init(
            data["clubname"],
            data["clubnb"],
            data["fednb"],
            data["status"],
            new DateTime.fromMillisecondsSinceEpoch(data["enddate"]["\$date"]));
  }

  String toString() => "Licence $clubname $clubnb, $fednb, $status";

  Map<String, dynamic> toJson() => {
        "clubname": clubname,
        "clubnb": clubnb,
        "fednb": fednb,
        "status": status,
        "enddate": enddate.toString()
      };
}

class Address implements DataImplement {
  String way, postalcode, city, number;

  Address()
      : way = "",
        postalcode = "",
        city = "",
        number = "";

  Address.init(this.number, this.way, this.postalcode, this.city)
      : assert(way != null),
        assert(number != null),
        assert(postalcode != null),
        assert(city != null);

  factory Address.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new Address.init(
            data["number"], data["way"], data["postalcode"], data["city"]);
  }

  String toString() => "Live at $number $way $postalcode $city";

  Map<String, dynamic> toJson() =>
      {"way": way, "postalcode": postalcode, "city": city, "number": number};
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

  DataUser.init(this.firstName, this.lastname, this.phone, this.genre,
      this.licenceNbr, this.birthday);

  factory DataUser.fromWebJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new DataUser.init(
            data['firstname'],
            data['lastname'],
            data['phone'],
            data['genre'],
            data['licenceNbr'],
            new DateTime.fromMillisecondsSinceEpoch(
                data['birthday']['\$date']));
  }

  factory DataUser.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new DataUser.init(
            data['firstname'],
            data['lastname'],
            data['phone'],
            data['genre'],
            data['licenceNbr'],
            DateTime.parse(data['birthday']));
  }

  String toString() => "User name $lastname de sex $genre";

  Map<String, dynamic> toJson() => {
        "firstname": firstName,
        "lastname": lastname,
        "phone": phone,
        "birthday": birthday.toString(),
        "genre": genre,
        "licenceNbr": licenceNbr
      };
}
