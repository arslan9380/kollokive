class UserModel {
  String id;
  String email;
  String school;
  String city;
  String degree;
  String fieldOfStudy;
  String semester;
  String imageUrl;
  String name;
  String age;
  String bio;
  List<String> subjects = [];
  String fcm;

  UserModel(
      {this.id,
      this.bio,
      this.email,
      this.school,
      this.city,
      this.degree,
      this.fieldOfStudy,
      this.semester,
      this.imageUrl,
      this.name,
      this.age,
      this.subjects,
      this.fcm});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'bio': this.bio,
      'email': this.email,
      'school': this.school,
      'city': this.city,
      'degree': this.degree,
      'fieldOfStudy': this.fieldOfStudy,
      'semester': this.semester,
      'imageUrl': this.imageUrl,
      'name': this.name,
      'age': this.age,
      'subjects': this.subjects,
      'fcm': this.fcm
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'] as String,
        bio: map['bio'],
        email: map['email'] as String,
        school: map['school'] as String,
        city: map['city'] as String,
        degree: map['degree'] as String,
        fieldOfStudy: map['fieldOfStudy'] as String,
        semester: map['semester'] as String,
        imageUrl: map['imageUrl'] as String,
        name: map['name'] as String,
        age: map['age'] as String,
        subjects: List.castFrom(map['subjects']),
        fcm: map['fcm']);
  }
}
