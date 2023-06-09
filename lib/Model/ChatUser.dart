class CharUser {
  String? image;
  String? about;
  String? name;
  String? lastActive;
  String? id;
  bool? isOnline;
  String? createAt;
  String? email;
  String? pushToken;

  CharUser(
      {this.image,
      this.about,
      this.name,
      this.lastActive,
      this.id,
      this.isOnline,
      this.createAt,
      this.email,
      this.pushToken});

  CharUser.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    about = json['about'];
    name = json['name'];
    lastActive = json['last_active'];
    id = json['id'];
    isOnline = json['is_online'];
    createAt = json['create_at'];
    email = json['email'];
    pushToken = json['push_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['about'] = this.about;
    data['name'] = this.name;
    data['last_active'] = this.lastActive;
    data['id'] = this.id;
    data['is_online'] = this.isOnline;
    data['create_at'] = this.createAt;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}
