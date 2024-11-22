import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // construir login do usuario
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // login do usuario
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Cadastro de novo usuário com informações extras
  Future<User?> registerWithEmail(
      String email, String password, String name, String cpf) async {
    try {
      // Criar o usuário no Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      // Salvar dados adicionais no Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'nome': name,
          'cpf': cpf,
          'email': email,
          'createdAt': Timestamp.now(),
        });
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // logout do usuario
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
