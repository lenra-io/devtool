class FakeUser {
  late String email;
  int userId;

  FakeUser(this.userId) {
    this.email = 'user${this.userId}@devtools.lenra.io';
  }

  Map<String, dynamic> toJson() => {"userId": this.userId, "email": this.email};
}
