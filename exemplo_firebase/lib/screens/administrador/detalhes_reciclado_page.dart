import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/user_data.dart';
import 'home_coleta_page.dart';

class DetalhesRecicladoPage extends StatefulWidget {
  final Map<String, dynamic> reciclado;

  DetalhesRecicladoPage({required this.reciclado});

  @override
  _DetalhesRecicladoPageState createState() => _DetalhesRecicladoPageState();
}

class _DetalhesRecicladoPageState extends State<DetalhesRecicladoPage> {
  bool _isLoading = false;

  final user = UserSession();

  Future<void> confirmarReciclado(
      String docId, Map<String, dynamic> reciclado, String uid) async {
    try {
      // Obter usuário autenticado
      final userCurrent = FirebaseAuth.instance.currentUser;
      if (userCurrent == null) {
        print("Erro: Nenhum usuário autenticado.");
        return;
      }
      print("Usuário autenticado: ${userCurrent.uid}");

      // Validar campos obrigatórios
      if (docId.isEmpty || uid.isEmpty) {
        print("Erro: docId ou uid está vazio.");
        return;
      }
      print("docId: $docId, uid: $uid");

      // Validar dados do reciclado
      if (reciclado == null || reciclado.isEmpty) {
        print("Erro: Dados do reciclado estão ausentes.");
        return;
      }
      print("Reciclado: $reciclado");

      // Fornecer valores padrão
      final timestamp = Timestamp.now();
      final xpGanho =
          (reciclado['qtd'] as num?)?.toInt() ?? 0; // Valor padrão: 0
      print("XP ganho calculado: $xpGanho");

      // Referência ao documento no Firestore
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reciclado')
          .doc(docId);

      // Verificar se o documento existe
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        print("Erro: Documento não encontrado para o ID: $docId");
        return;
      }
      print("Documento encontrado: ${docSnapshot.data()}");

      // Atualizar o documento no Firestore
      await docRef.update({
        'status': 'Concluído',
        'data_coleta': timestamp,
        'xp_ganho': xpGanho,
        'checked_by': userCurrent.uid, // Garantir que o UID está correto
      });

      print("Documento atualizado com sucesso!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reciclado confirmado com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );

      // Voltar para a página anterior
      Navigator.pop(context);
    } catch (e) {
      print("Erro ao confirmar reciclado: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao confirmar reciclado. Tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleConfirmation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final id = widget.reciclado['id'];
      final userId = widget.reciclado['userId'];

      // Verificar se os campos obrigatórios estão presentes
      if (id == null || userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: Dados do reciclado incompletos.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Chamar a função de confirmação
      await confirmarReciclado(id, widget.reciclado, userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reciclado confirmado com sucesso!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeColetaPage()),
        (route) => false,
      );
    } catch (e) {
      print("Erro ao confirmar reciclado: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao confirmar reciclado. Tente novamente.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Detalhes do Reciclado',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: _isLoading ? _buildLoadingView() : _buildDetailsView(),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF795548)), // Brown progress indicator
            ),
            SizedBox(height: 16),
            Text(
              'Confirmando reciclagem...',
              style: TextStyle(
                  color: Color(0xFF795548), fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsView() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exibe os detalhes
                      _buildDetailItem(
                        icon: Icons.category,
                        title: 'Tipo',
                        value:
                            widget.reciclado['tipo'] ?? 'Tipo não disponível',
                        isImportant: true,
                      ),
                      _buildDetailItem(
                        icon: Icons.scale,
                        title: 'Quantidade',
                        value: widget.reciclado['qtd']?.toString() ??
                            'Não disponível',
                      ),
                      _buildDetailItem(
                        icon: Icons.check_circle_outline,
                        title: 'Status',
                        value: widget.reciclado['status'] ?? 'Não informado',
                      ),
                      if (widget.reciclado['nome'] != null) ...[
                        _buildDetailItem(
                          icon: Icons.person,
                          title: 'Usuário',
                          value: widget.reciclado['nome'],
                        ),
                        _buildDetailItem(
                          icon: Icons.credit_card,
                          title: 'CPF',
                          value: widget.reciclado['cpf'],
                        ),
                      ],
                      if (widget.reciclado['endereco'] != null) ...[
                        _buildDetailItem(
                          icon: Icons.location_on,
                          title: 'Endereço',
                          value:
                              'CEP: ${widget.reciclado['endereco']['cep'] ?? 'Não informado'}\n'
                              'Bairro: ${widget.reciclado['endereco']['bairro'] ?? 'Não informado'}',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Não Confirmar',
                      style: TextStyle(color: Color(0xFF795548)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleConfirmation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: const Color(0xFFFFFFFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    bool isImportant = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Color(0xFF795548),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF795548),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isImportant ? 18 : 16,
                    fontWeight:
                        isImportant ? FontWeight.bold : FontWeight.normal,
                    color:
                        isImportant ? const Color(0xFF2E7D32) : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
