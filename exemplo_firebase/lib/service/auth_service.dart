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
  Future<User?> registerWithEmail(String email, String password, String name,
      String cpf) async {
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

  Future<String?> getUserUid() async {
    // Obtém o usuário autenticado
    User? user = FirebaseAuth.instance.currentUser;

    // Verifica se o usuário está autenticado e retorna o UID
    if (user != null) {
      return user.uid;
    } else {
      return null; // Retorna null se o usuário não estiver autenticado
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      // Obtém o UID do usuário logado
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Busca os dados do usuário no Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users') // Coleção onde os dados estão armazenados
            .doc(uid) // Documento com o UID do usuário
            .get();

        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: ${e.toString()}");
    }
    return null;
  }
}