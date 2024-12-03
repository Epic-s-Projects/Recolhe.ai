import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen_view.dart';

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
          'doc_id': user.uid,  // Salvando explicitamente o UID no Firestore
        });
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Após o logout, redireciona para a LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao sair: $e')),
      );
    }
  }
}
