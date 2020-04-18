import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String imageUrl;
  final bool isLogin;
  final DateTime lastActivity;
  final String nom;
  final String password;
  final String provider;
  final List chat;
  final Map chatId;

  User(
      {this.id,
      this.email,
      this.imageUrl,
      this.isLogin,
      this.lastActivity,
      this.nom,
      this.password,
      this.provider,
        this.chat,
      this.chatId});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'imageUrl': this.imageUrl,
      'isLogin': this.isLogin,
      'lastActivity': this.lastActivity,
      'nom': this.nom,
      'password': this.password,
      'provider': this.provider,
      'chat': this.chat,
      'chatId': this.chatId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String documentId) {
    Timestamp time = map['lastActivity'] ?? '';
    return new User(
      id: documentId,
      email: map['email'] as String,
      imageUrl: map['imageUrl'] as String,
      isLogin: map['isLogin'] as bool,
      lastActivity: time.toDate(),
      nom: map['nom'] as String,
      password: map['password'] as String,
      provider: map['provider'] as String,
      chat: map['chat'] as List,
      chatId: map['chatId'] as Map,
    );
  }

//  Map<String, dynamic> toMap() {
//    return {
//      'id': this.id,
//      'email': this.email,
//      'imageUrl': this.imageUrl,
//      'isLogin': this.isLogin,
//      'lastActivity': this.lastActivity,
//      'nom': this.nom,
//      'password': this.password,
//      'provider': this.provider,
//    };
//  }
//
//  factory User.fromMap(Map<String, dynamic> map, String documentId) {
//    Timestamp time = map['lastActivity'] ?? '';
//    return User(
//      id: documentId,
//      email: map['email'] as String,
//      imageUrl: map['imageUrl'] as String ??
//          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrWfWLnxIT5TnuE-JViLzLuro9IID2d7QEc2sRPTRoGWpgJV75",
//      isLogin: map['isLogin'] as bool,
//      lastActivity: time.toDate(),
//      nom: map['nom'] as String,
//      password: map['password'] as String,
//      provider: map['provider'] as String,
//      chatId: map['chatId'] == null
//          ? {}
//          :Map.fromIterable(map['chatId'] as List,
//          key: (v) => v.toString().substring(
//              v.toString().indexOf('{') + 1, v.toString().indexOf(':')),
//          value: (v) => v
//              .toString()
//              .substring(
//                  v.toString().indexOf(':') + 1, v.toString().indexOf('}'))
//              .trim()), //sur firestore c'est une list
//    );
//  }

//  Map<String, dynamic> toMap() {
//    return {
//      'id': id,
//      'nom': nom,
//      'imageUrl': imageUrl,
//      'email': email,
//      'password': password,
//      'lastActivity': lastActivity,
//      'provider': provider,
//      'isLogin': isLogin,
//      'chat': chat,
//      'chatId': chatId
//    };
//  }
//
//  factory User.fromMap(Map data, String documentId) {
//    return User(
//      id: documentId,
//      email: data['email'] ?? '',
//      isLogin: data['isLogin'] ?? false,
//      imageUrl: data['imageUrl'] ??
//          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrWfWLnxIT5TnuE-JViLzLuro9IID2d7QEc2sRPTRoGWpgJV75",
//      lastActivity: data['lastActivity'],
//      nom: data['nom'] ?? '',
//      password: data['password'] ?? '',
//      provider: data['provider'] ?? '',
//      willAttend: data['willAttend'] as List ?? [],
//      attended: data['attended'] as List ?? [],
//      chat: data['chat'] as List ?? [],
//      chatId: data['chatId'].toString().length == 2
//          ? {}
//          : Map.fromIterable((data['chatId'] as List), //2 = est vide
//          key: (v) =>  v.toString().substring(
//              v.toString().indexOf('{') + 1, v.toString().indexOf(':')),
//          value: (v) => v
//              .toString()
//              .substring(
//              v.toString().indexOf(':') + 1, v.toString().indexOf('}'))
//              .trim()),
//    );
//  }
//
//  @override
//  String toString() => 'User { name: $nom }';
}
