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
    Timestamp dateDebut = map['dateDebut'] ?? '';
    Timestamp dateFin = map['dateFin'] ?? '';

    return new Event(
      id: documentId,
      titre: map['titre'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      dateDebut: dateDebut.toDate(),
      dateFin: dateFin.toDate(),
      nbParticipant: map['nbParticipant'] as int ?? 0,
      nbExpected: map['nbExpected'] as int ?? 0,
      status: map['status'] as String,
    );
  }

}