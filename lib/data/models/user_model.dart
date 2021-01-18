
class User {
  int id;
  String name;
  String email;
  String city;
  String gender;
  double lat;
  double long;
  int points;
  String address;
  String mobile;
  String emailVerifiedAt;
  String image;
  String aboutMe;

  User({
    this.id,
    this.name,
    this.email,
    this.city,
    this.gender,
    this.image,
    this.emailVerifiedAt,
    this.lat,
    this.long,
    this.mobile,
    this.points=0,
    this.address,
    this.aboutMe
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        //This will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into a User object
        id:data['id'],
        name: data['name'],
        email: data['email'],
        emailVerifiedAt: data['email_verified_at'],
        image: data['image'].toString(),
        lat: double.tryParse(data['lat'].toString()),
        long: double.tryParse(data['long'].toString()),
        gender: data['gender'],
        city: data['city'],
        mobile:data['mobile'],
        points:int.tryParse(data['points'].toString()),
        address: data['address'],
        aboutMe: data['about_me']
      );
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'name': name,
    'email': email,
    'image': image,
    'points':points,
    'address':address,
    'lat':lat,
    'long':long,
    'about_me':aboutMe,
    'email_verified_at':emailVerifiedAt
  };

  Map<String, dynamic> toUpdateJson() => {
    'name': name,
    'email': email,
    'image': image,
    'points':points,
    'address':address,
    'lat':lat,
    'long':long,
    'about_me':aboutMe

  };
}
