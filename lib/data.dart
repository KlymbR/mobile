String tokenGlobal;


const String serverdata = '''
{  
   "success":true,
   "result":{  
      "address":{  
         "number":43,
         "street":"totoStreet",
         "postalCode":78800,
         "city":"Houilles"
      },
      "licenses":[  
         {  
            "licenseNbr":"12343",
            "clubName":"totoScalade",
            "clubId":"1",
            "fedId":"1",
            "endDate":"1994-06-28",
            "status":"1"
         }
      ],
      "_id":"5af3c703c59ac52f7a4c2ca7",
      "id":"1",
      "firstName":"Avel",
      "lastName":"Docquin",
      "email":"adocquin@outlook.com",
      "phone":"624350681",
      "gender":1,
      "birthdate":"1994-06-28T00:00:00.000Z",
      "isAdmin":false,
      "hashPassword":"\$2a\$10\$ypXs7ilQ9.qFTS63uQCOSeq5R1fdIXIILdwg.mBBiw3Wm4.9FNHFa",
      "createdDate":"2018-05-10T04:13:55.566Z",
      "__v":0
   }
}
''';

const String personaldata = '''
{
"firstname": "Kevin",
"lastname": "Barre",
"phone": "699709887",
"genre": "Monsieur",
"birthday":  {\"\$date\": 1512980682785},
"licenceNbr": "4567890",
"licences": [
  {
    "clubname": "Toto's club",
    "clubnb": "123123",
    "fednb": "1210",
    "enddate": {\"\$date\": 1512980682785},
    "status": "Actif"
  },
  {
    "clubname": "Jacquie club",
    "clubnb": "696969",
    "fednb": "1210",
    "enddate": {\"\$date\": 1512980682785},
    "status": "Actif"
  },
  {
    "clubname": "Michel club",
    "clubnb": "171717",
    "fednb": "1216",
    "enddate": {\"\$date\": 1512980682785},
    "status": "Désactivé"
  }
],
"address": {
"number": "6",
"way": "Rue du stade",
"postalcode": "04100",
"city": "Manosque"
}
}
''';

const String serverways = '''
{
"success":true,
"result":[
    {
      "grips":[
                {
                "grip_id":1,
                "grip_data":234,
                "grip_on":true
                },
                {
                "grip_id":2,
                "grip_data":234,
                "grip_on":true
                }
              ],
        "_id":"5a8336aa70af9206947347fe",
        "path_id":1,
        "path_free":true,
        "path_difficulty":"6A"
    }
  ]
}
''';

const String serverstats = '''
{  
    "_id": "5af353eec1fcd600c8bcdfc2",  
    "path_id": 1,  
    "path_difficulty": "6A",  
    "average_time": 76,  
    "best_time": 53,  
    "best_firstName": "Sofiane",
    "best_lastName": "Zermani",
    "__v": 0
}
''';

const String climbways = '''
{
    "ways": [
     {
        "wayNbr": 5,
        "difficulty": "C5",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Occupé"
     },
     {
        "wayNbr": 1,
        "difficulty": "A1",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Libre"
     },
     {
        "wayNbr": 2,
        "difficulty": "B1",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Libre"
     },
     {
        "wayNbr": 3,
        "difficulty": "B2",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Libre"
     },
     {
        "wayNbr": 4,
        "difficulty": "C1",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Libre"
     },
     {
        "wayNbr": 6,
        "difficulty": "K1",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Libre"
     },
     {
        "wayNbr": 7,
        "difficulty": "A1",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Libre"
     },
     {
        "wayNbr": 8,
        "difficulty": "A1",
        "personaBestTime": {
          "time": 72,
          "\$date\": 1512980682785
        },
        "bestTime": {
          "time" :  65,
          "firstname": "Jhon",
          "lastname": "Travolta",
          "\$date\": 1512980682785
        },
        "disponibility": "Occupé"
     }
    ]
}
''';


const String dataMap = """
{
    "success": true,
    "result":
    [  
        {
            "_id": "5ae9bacba0617f3a64b1c67f",  
	        "title":"totoScalade",  
	        "latitude":48.842886,  
	        "longitude":2.357254,  
            "__v": 0
        }
    ]  
}
""";


const String blueTooth = '''

''';