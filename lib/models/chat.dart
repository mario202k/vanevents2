import 'package:cloud_firestore/cloud_firestore.dart';

class MyChat {
  final String id;
  final DateTime createdAt;
  final Map groupe;
  final List uid;
  final bool isGroupe;
  final String imageUrl;
  final String titre;

  MyChat(
      {this.id,
      this.createdAt,
      this.groupe,
      this.uid,
      this.isGroupe,
      this.imageUrl,
      this.titre});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'createdAt': this.createdAt,
      'groupe': this.groupe,
      'isGroupe': this.isGroupe,
      'uid': this.uid,
      'imageUrl': this.imageUrl,
      'titre':this.titre,
    };
  }

  factory MyChat.fromMap(Map<String, dynamic> map) {
    Timestamp createdAt = map['createdAt'] ?? '';
    return new MyChat(
      id: map['id'] as String,
      createdAt: createdAt.toDate(),
      groupe: map['groupe'] as Map ?? {},
      isGroupe: map['isGroupe'] as bool ?? false,
      uid: map['uid'] as List ?? [],
      imageUrl: map['imageUrl'] as String ?? '',
      titre:  map['titre'] as String ?? '',
    );
  }
}
