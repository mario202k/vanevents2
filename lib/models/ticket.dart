import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vanevents/models/participant.dart';

class Ticket{
  final String id;
  final String status;
  final String uid;
  final String eventId;
  final int nbParticipants;
  final Map participant;
  final int amount;
  final DateTime dateTime;
  final int receiptNumber;

  Ticket({this.id,this.status,this.uid, this.eventId, this.nbParticipants, this.participant,
      this.amount, this.dateTime, this.receiptNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'status':this.status,
      'uid': this.uid,
      'eventId': this.eventId,
      'nbParticipants': this.nbParticipants,
      'participant': this.participant,
      'amount': this.amount,
      'dateTime': this.dateTime,
      'receiptNumber': this.receiptNumber,
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    Timestamp time = map['dateTime'] ?? '';

    return Ticket(
      id: map['id'] as String,
      status: map['status'] as String,
      uid: map['uid'] as String,
      eventId: map['eventId'] as String,
      nbParticipants: map['nbParticipants'] as int,
      participant: map['participant'] as Map,
      amount: map['amount'] as int,
      dateTime: time.toDate(),
      receiptNumber: map['receiptNumber'] as int,
    );
  }
}