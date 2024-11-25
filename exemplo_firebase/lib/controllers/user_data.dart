import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  // Dados do usuário
  String? name;
  String? cpf;
  String? email;
  String? imagem;
  String? userId; // Variável para armazenar o ID do documento

  // Método para buscar os dados do Firestore
  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      email = user.email; // Email já vem do Firebase Authentication

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        name = data?['name'];
        cpf = data?['cpf'];
        imagem = data?['imagem'];

        // Atribuindo o ID do documento
        userId = userDoc.id;
      } else {
        throw Exception('Dados do usuário não encontrados.');
      }
    } else {
      throw Exception('Usuário não autenticado.');
    }
  }
}
