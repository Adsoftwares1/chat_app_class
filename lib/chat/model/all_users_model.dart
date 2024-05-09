class AllUsersModel {
  String name;
  String profileImage;
  String email;
  String userId;

  AllUsersModel({
    required this.name,
    required this.profileImage,
    required this.email,
    required this.userId,
  });

  factory AllUsersModel.fromJson(Map<String, dynamic> json) {
    return AllUsersModel(
      name: json['name'],
      profileImage: json['profile_image'],
      email: json['email'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['email'] = this.email;
    data['userId'] = this.userId;
    return data;
  }
}
