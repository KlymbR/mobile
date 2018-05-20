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
  String clubName, licenseNbr, clubId, status, fedId;
  DateTime endDate;

  Licences()
      : clubName = "",
        licenseNbr = "",
        clubId = "",
        status = "",
        fedId = "",
        endDate = new DateTime.now();

  Licences.init(this.clubName, this.licenseNbr, this.clubId, this.status,
      this.fedId, this.endDate);

  factory Licences.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new Licences.init(data["clubname"], data["licenseNbr"], data["fednb"],
            data["status"], data["fedId"], DateTime.parse(data["endDate"]));
  }

  String toString() =>
      "Licence $clubName $licenseNbr, $clubId, $status, $fedId, $endDate";

  Map<String, dynamic> toJson() => {
        "clubName": clubName,
        "licenseNbr": licenseNbr,
        "clubId": clubId,
        "status": status,
        "fedId": fedId,
        "endDate": endDate.toString()
      };
}

class Address implements DataImplement {
  String street, city;
  int number, postalCode;

  Address()
      : street = "",
        postalCode = 0,
        city = "",
        number = 0;

  Address.init(this.number, this.street, this.postalCode, this.city)
      : assert(street != null),
        assert(number != null),
        assert(postalCode != null),
        assert(city != null);

  factory Address.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new Address.init(
            data["number"], data["street"], data["postalCode"], data["city"]);
  }

  String toString() => "Live at $number $street $postalCode $city";

  Map<String, dynamic> toJson() => {
        "street": street,
        "postalCode": postalCode,
        "city": city,
        "number": number
      };
}

class DataUser implements DataImplement {
  String email, firstName, lastName, phone, licenceNbr;
  DateTime birthdate;
  int gender;

  DataUser()
      : birthdate = new DateTime.now(),
        gender = 1,
        lastName = "",
        phone = "",
        firstName = "",
        licenceNbr = "";

  DataUser.init(this.email, this.firstName, this.lastName, this.phone, this.gender,
      this.birthdate, this.licenceNbr);

  factory DataUser.fromJson(Map<String, dynamic> data) {
    return data == null
        ? null
        : new DataUser.init(data['email'], data['firstName'], data['lastName'], data['phone'],
            data['gender'], DateTime.parse(data['birthdate']), data['licenceNbr']);
  }

  String toString() => "User name $lastName de sex $gender";

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "birthdate": birthdate.toString(),
        "gender": gender,
      };
}
