import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String id;
  final String titre;
  final String description;
  final String imageUrl;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int nbParticipant;
  final int nbExpected;
  final String status;


  Event({this.id, this.titre, this.description, this.imageUrl, this.dateDebut,
      this.dateFin, this.nbExpected,this.nbParticipant,this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'titre': this.titre,
      'description': this.description,
      'imageUrl': this.imageUrl,
      'dateDebut': this.dateDebut,
      'dateFin': this.dateFin,
      'nbParticipant': this.nbParticipant,
      'nbExpected': this.nbExpected,
      'status': this.status,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map,String documentId) {
    return new Event(
      id: documentId,
      titre: map['titre'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      dateDebut: map['dateDebut'] as DateTime,
      dateFin: map['dateFin'] as DateTime,
      nbParticipant: map['nbParticipant'] as int,
      nbExpected: map['nbExpected'] as int,
      status: map['status'] as String,
    );
  }

}