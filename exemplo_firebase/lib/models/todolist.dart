import 'package:cloud_firestore/cloud_firestore.dart';

class Todolist {
  //atributos
  final String id;
  final String titulo;
  final String userId;
  final DateTime timestamp;

  Todolist({required this.id, required this.titulo, required this.userId, required this.timestamp});

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'userid': userId,
      'timestamp': timestamp
    };
  }
  // fromMap
  factory Todolist.fromMap(Map<String, dynamic> map, String doc) {
    return Todolist(
      id: doc,
      titulo: map['titulo'],
      userId: map['userid'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}