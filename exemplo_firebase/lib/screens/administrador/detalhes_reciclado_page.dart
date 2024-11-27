import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/user_data.dart';

class DetalhesRecicladoPage extends StatelessWidget {
  final Map<String, dynamic> reciclado;

  DetalhesRecicladoPage({required this.reciclado});

  final user = UserSession();

  Future<void> confirmarReciclado(String docId, Map<String, dynamic> reciclado, String uid) async {
    try {

      // Garante que o usuário está autenticado
      final userCurrent = FirebaseAuth.instance.currentUser;
      if (userCurrent == null) {
        print("Erro: Nenhum usuário autenticado.");
        return;
      }

      final timestamp = Timestamp.now();
      final xpGanho = reciclado['qtd'] ?? 0;

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid) // Documento do usuário (UID)
          .collection('reciclado')
          .doc(docId); // Documento do reciclado

      // Verifique se o documento existe
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        print("Documento não encontrado para o ID: $docId");
        return;
      }

      // Atualize os dados
      await docRef.update({
        'status': 'Concluído',
        'data_coleta': timestamp,
        'xp_ganho': xpGanho,
        'checked_by': userCurrent.uid
      });

      print("Documento atualizado com sucesso!");
    } catch (e) {
      print("Erro ao atualizar reciclado: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Reciclado'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reciclado['tipo'] ?? 'Tipo não disponível',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Quantidade: ${reciclado['qtd'] ?? 'Não disponível'}'),
            Text('Status: ${reciclado['status'] ?? 'Não informado'}'),
            if (reciclado['nome'] != null) ...[
              SizedBox(height: 16),
              Text('Usuário: ${reciclado['nome']}'),
              Text('CPF: ${reciclado['cpf']}'),
            ],
            if (reciclado['endereco'] != null) ...[
              SizedBox(height: 16),
              Text('Endereço:'),
              Text('Rua: ${reciclado['endereco']['cep'] ?? 'Não informado'}'),
              Text('Bairro: ${reciclado['endereco']['bairro'] ?? 'Não informado'}'),
              Text('DocID: ${reciclado['userId'] ?? 'Não informado'}'),
            ],
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Volta para a página anterior
                  },
                  child: Text('Não Confirmar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Reciclado: $reciclado"); // Debug para verificar os dados do reciclado
                    print("ID do documento: ${reciclado['id']}");
                    String uid = reciclado['userId'];
                    await confirmarReciclado(reciclado['id'], reciclado, uid);

                    Navigator.pop(context); // Volta para a página anterior
                  },
                  child: Text('Confirmar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
