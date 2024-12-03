import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/screens/cadastro_endereco_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/intern_screen_view.dart';

class OilRegisterControllers {
  int _oilAmount = 0;

  void increment() {
    _oilAmount += 500;
  }

  void decrement() {
    if (_oilAmount > 0) {
      _oilAmount -= 500;
    }
  }

  int getOilAmount() {
    return _oilAmount;
  }

  Future<void> addRecycledData(
      String tipo, String status, BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final uid = user.uid;

        // Verifica se o usuário tem um endereço cadastrado
        final enderecoSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("endereco")
            .get();

        print(
            "Documentos de endereço encontrados: ${enderecoSnapshot.docs.length}");

        if (enderecoSnapshot.docs.isEmpty) {
          print("Nenhum endereço cadastrado encontrado.");

          // Exibe o diálogo e retorna para interromper o fluxo
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFFF5F5F5), // Cor de fundo suave
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Bordas arredondadas
                ),
                title: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 30),
                    const SizedBox(width: 10),
                    const Text(
                      "Endereço não cadastrado",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                content: const Text(
                  "Você precisa cadastrar um endereço antes de continuar.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666), // Cor do texto
                  ),
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModernAddressRegistrationPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF4CAF50), // Verde
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add_location_alt, size: 20),
                    label: const Text(
                      "Cadastrar Endereço",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha apenas o diálogo
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFD32F2F), // Vermelho
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 20),
                    label: const Text(
                      "Voltar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          );

          return; // Interrompe a execução do método
        }

        // Dados a serem adicionados
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

        // Atualiza o documento com o ID
        await docRef.update({
          'id': docId,
        });

        // Exibe o SnackBar de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Óleo adicionado com sucesso!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );

        // Navega para a HomeColetaPage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
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
