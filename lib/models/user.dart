import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? email;
  final String? uid;
  final String? photoUrl;
  final String? username;
  final String? bio;
  final List? followers;
  final List? following;

  const User(
      {this.username,
      this.uid,
      this.photoUrl,
      this.email,
      this.bio,
      this.followers,
      this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };
}
