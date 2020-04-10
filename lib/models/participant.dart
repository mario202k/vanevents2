import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vanevents/models/formule.dart';

class Participant{
  GlobalKey<FormBuilderState> fbKey;
  int index;
  Formule formule;
  String nom;
  String prenom;


  Participant({this.fbKey,this.index,this.formule, this.nom, this.prenom});

  Map<String, dynamic> toMap() {
    return {
      'formule': this.formule,
      'nom': this.nom,
      'prenom': this.prenom,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return new Participant(
      formule: map['formule'] as Formule,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
    );
  }

}