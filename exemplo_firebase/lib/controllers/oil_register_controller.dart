import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OilRegisterControllers {
  int _oilAmount = 0;

  // Incrementa a quantidade de óleo
  void increment() {
    _oilAmount += 500; // Incrementa 100ml por clique
  }

  // Decrementa a quantidade de óleo
  void decrement() {
    if (_oilAmount > 0) {
      _oilAmount -= 500; // Decrementa 100ml por clique
    }
  }

  // Obtém a quantidade atual de óleo
  int getOilAmount() {
    return _oilAmount;
  }

  // Adiciona dados à subcoleção 'reciclado'
  Future<void> addRecycledData(String tipo, String status) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final uid = user.uid;

        // Dados a serem adicionados na subcoleção
        final data = {
          "qtd": _oilAmount,
          "tipo": tipo,
          "timestamp": FieldValue.serverTimestamp(),
          "status": status
        };

        // Adiciona à subcoleção 'reciclado'
        final docRef = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("reciclado")
            .add(data);

        final docId = docRef.id;

        await docRef.update({
          'id': docId, // Adiciona o ID ao próprio documento
        });

        print("Dados adicionados com sucesso!");
      } else {
        print("Usuário não autenticado.");
      }
    } catch (e) {
      print("Erro ao adicionar dados: $e");
    }
  }
}
