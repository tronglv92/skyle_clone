class DBUser {
  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  DBUser({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
  });

  Map toJson(DBUser user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["status"] = user.status;
    data["state"] = user.state;
    data["profile_photo"] = user.profilePhoto;
    return data;
  }

  // Named constructor
  DBUser.fromJson(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'DBUser{uid: $uid, name: $name, email: $email, username: $username}, status: $status}, state: $state}, profilePhoto: $profilePhoto}';
  }
}
