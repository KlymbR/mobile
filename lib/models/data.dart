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
  String clubname;
  DateTime end;
  int status, number, fed, clubid;

  Licences()
      : clubname = "",
        number = 0,
        clubid = 0,
        status = 0,
        fed = 0,
        end = new DateTime.now();

  Licences.init(this.clubname, this.number, this.clubid, this.status,
      this.fed, this.end);

  factory Licences.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new Licences.init(data["club"]["name"], data["number"], data["club"]["id"],
            data["status"], data["fed"], DateTime.parse(data["end"]));
  }

  String toString() =>
      "Licence $clubname $number, $clubid, $status, $fed, $end";

  Map<String, dynamic> toJson() => {
        "club": {"name": clubname, "id": clubid},
        "number": number,
        "status": status,
        "fed": fed,
        "end": end.toString()
      };
}

class Address implements DataImplement {
  String street, city;
  int number, postalcode;

  Address()
      : street = "",
        postalcode = 0,
        city = "",
        number = 0;

  Address.init(this.number, this.street, this.postalcode, this.city)
      : assert(street != null),
        assert(number != null),
        assert(postalcode != null),
        assert(city != null);

  factory Address.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new Address.init(
            data["number"], data["street"], data["postalcode"], data["city"]);
  }

  String toString() => "Live at $number $street $postalcode $city";

  Map<String, dynamic> toJson() => {
        "street": street,
        "postalcode": postalcode,
        "city": city,
        "number": number
      };
}

class DataUser implements DataImplement {
  String email, firstname, lastname, phone, licencenbr, id;
  DateTime birthdate;
  int gender;

  DataUser()
      : birthdate = new DateTime.now(),
        gender = 1,
        lastname = "",
        phone = "",
        firstname = "",
        id = "",
        licencenbr = "";

  DataUser.init(this.id, this.email, this.firstname, this.lastname, this.phone, this.gender,
      this.birthdate, this.licencenbr);

  factory DataUser.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new DataUser.init(data['_id'], data['email'], data['firstname'], data['lastname'], data['phone'],
            data['gender'], DateTime.parse(data['birthdate']), data['licencenbr']);
  }

  String toString() => "User name $lastname de sex $gender";

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "birthdate": birthdate.toString(),
        "gender": gender,
        "licencenbr": licencenbr
      };
}
