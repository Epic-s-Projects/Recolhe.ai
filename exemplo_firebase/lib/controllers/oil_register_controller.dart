import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/administrador/home_coleta_page.dart';

class OilRegisterControllers {
  int _oilAmount = 0;

  // Incrementa a quantidade de óleo
  void increment() {
    _oilAmount += 100; // Incrementa 100ml por clique
  }

  // Decrementa a quantidade de óleo
  void decrement() {
    if (_oilAmount > 0) {
      _oilAmount -= 100; // Decrementa 100ml por clique
    }
  }

  // Obtém a quantidade atual de óleo
  int getOilAmount() {
    return _oilAmount;
  }

  // Adiciona dados à subcoleção 'reciclado'
  Future<void> addRecycledData(
      String tipo, String status, BuildContext context) async {
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

        // Exibe o SnackBar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Óleo adicionado com sucesso!'),
            backgroundColor: Color(0xFF4CAF50), // Green success color
          ),
        );

        // Navega para a HomeColetaPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeColetaPage()),
              (route) => false,
        );
      } else {
        print("Usuário não autenticado.");
      }
    } catch (e) {
      print("Erro ao confirmar reciclado: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao confirmar reciclado. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
