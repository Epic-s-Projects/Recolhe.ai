import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/app_bar_adm.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:flutter/material.dart';

import 'detalhes_reciclado_page.dart';

class RecicladosPorEnderecoPage extends StatefulWidget {
  final Map<String, dynamic> endereco;

  RecicladosPorEnderecoPage({required this.endereco});

  @override
  _RecicladosPorEnderecoPageState createState() =>
      _RecicladosPorEnderecoPageState();
}

class _RecicladosPorEnderecoPageState extends State<RecicladosPorEnderecoPage> {
  List<Map<String, dynamic>> reciclados = [];
  bool isLoading = true;
  final user = UserSession();

  @override
  void initState() {
    super.initState();
    _loadReciclados();
  }

  Future<void> _loadReciclados() async {
    try {
      List<Map<String, dynamic>> data =
          await fetchRecicladosPorEndereco(widget.endereco);
      setState(() {
        reciclados = data;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar reciclados: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecicladosPorEndereco(
      Map<String, dynamic> enderecoFiltro) async {
    List<Map<String, dynamic>> allReciclados = [];

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        DocumentSnapshot enderecoDoc = await userDoc.reference
            .collection("endereco")
            .doc("main_address")
            .get();

        if (enderecoDoc.exists) {
          final enderecoData = enderecoDoc.data() as Map<String, dynamic>;

          final bool enderecoCorresponde = (enderecoFiltro['bairro'] == null ||
                  enderecoData['bairro'] == enderecoFiltro['bairro']) &&
              (enderecoFiltro['cep'] == null ||
                  enderecoData['cep'] == enderecoFiltro['cep']) &&
              (enderecoFiltro['numero'] == null ||
                  enderecoData['numero'] == enderecoFiltro['numero']) &&
              (enderecoFiltro['rua'] == null ||
                  enderecoData['rua'] == enderecoFiltro['rua']);

          if (enderecoCorresponde) {
            // Adiciona o filtro para "status" no query para reciclado
            QuerySnapshot recicladoSnapshot = await userDoc.reference
                .collection("reciclado")
                .where("status", isEqualTo: "Em processo")
                .get();

            for (QueryDocumentSnapshot recicladoDoc in recicladoSnapshot.docs) {
              allReciclados.add({
                ...recicladoDoc.data() as Map<String, dynamic>,
                'recicladoId': recicladoDoc.id,
                'userId': userDoc.id,
                'endereco': enderecoData,
              });
            }
          }
        }
      }
    } catch (e) {
      print("Erro ao buscar reciclados: $e");
    }

    return allReciclados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarADM(user: user),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgound.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF795548)),
                  ),
                )
              : reciclados.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum reciclado encontrado para este endereço.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF795548),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : _buildRecicladosList(),
        ),
      ),
    );
  }

  Widget _buildRecicladosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: reciclados.length,
      itemBuilder: (context, index) {
        final reciclado = reciclados[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetalhesRecicladoPage(reciclado: reciclado),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reciclado['tipo'] ?? 'Tipo não disponível',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reciclado['status'] ?? 'Status não disponível',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (reciclado['qtd'] != null)
                    Text(
                      'Quantidade: ${reciclado['qtd']}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
