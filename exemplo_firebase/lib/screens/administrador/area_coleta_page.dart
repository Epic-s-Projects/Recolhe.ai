import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:flutter/material.dart';
import 'detalhes_reciclado_page.dart';
import 'home_adm_page.dart';
import 'home_coleta_page.dart';
import 'profile_adm_page.dart';

class AreaColetaPage extends StatefulWidget {
  @override
  _AreaColetaPageState createState() => _AreaColetaPageState();
}

class _AreaColetaPageState extends State<AreaColetaPage> {
  bool showMapCard = false; // Controla se o card do mapa será exibido
  int _selectedIndex = 1; // Define o índice inicial para esta página
  final user = UserSession();

  List<Map<String, dynamic>> reciclados = []; // Lista de reciclados
  bool isLoading = true; // Estado de carregamento dos dados

  final List<Widget> _pages = [
    HomeAdmPage(),
    AreaColetaPage(),
    HomeColetaPage(),
    const ProfileScreenADM(),
  ];

  @override
  void initState() {
    super.initState();
    _loadReciclados(); // Carrega os reciclados ao iniciar
  }

  Future<void> _loadReciclados() async {
    try {
      List<Map<String, dynamic>> data = await fetchAllReciclado();
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

  Future<List<Map<String, dynamic>>> fetchAllReciclado() async {
    List<Map<String, dynamic>> allReciclado = [];

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        // Pega o nome e CPF do usuário diretamente da coleção "users"
        final userData = userDoc.data() as Map<String, dynamic>;
        String? nome = userData['nome'];
        String? cpf = userData['cpf'];
        String userId = userDoc.id; // ID do documento do usuário

        // Busca os reciclados na subcoleção "reciclado"
        QuerySnapshot recicladoSnapshot = await userDoc.reference
            .collection("reciclado")
            .where("status", isEqualTo: "Em processo")
            .get();

        // Busca o endereço na subcoleção "endereco"
        QuerySnapshot enderecoSnapshot =
            await userDoc.reference.collection("endereco").get();

        Map<String, dynamic>? endereco;
        if (enderecoSnapshot.docs.isNotEmpty) {
          endereco = enderecoSnapshot.docs.first.data() as Map<String, dynamic>;
        }

        // Adiciona os dados de reciclado com informações do usuário e endereço
        for (QueryDocumentSnapshot recicladoDoc in recicladoSnapshot.docs) {
          allReciclado.add({
            ...recicladoDoc.data() as Map<String, dynamic>,
            'nome': nome,
            'cpf': cpf,
            'endereco': endereco,
            'userId': userId, // Inclui o ID do documento do usuário
            'recicladoId':
                recicladoDoc.id, // Inclui o ID do documento do reciclado
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar reciclados: $e");
    }

    return allReciclado;
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      ).then((_) {
        setState(() {
          _selectedIndex = index;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          user: user), // Remove qualquer botão de voltar automático
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Indicador de carregamento
          : reciclados.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum reciclado encontrado.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
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
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Exibe os dados do reciclado
                              Text(
                                reciclado['tipo'] ?? 'Tipo não disponível',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  'Quantidade: ${reciclado['qtd'] ?? 'Não disponível'}'),
                              const SizedBox(height: 8),
                              Text(
                                  'Status: ${reciclado['status'] ?? 'Não informado'}'),
                              const SizedBox(height: 8),
                              // Exibe o nome e CPF do usuário
                              Text(
                                'Usuário: ${reciclado['nome'] ?? 'Nome não disponível'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  'CPF: ${reciclado['cpf'] ?? 'CPF não informado'}'),
                              const SizedBox(height: 8),
                              // Exibe o endereço, se disponível
                              if (reciclado['endereco'] != null) ...[
                                const Text('Endereço:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    'Rua: ${reciclado['endereco']['cep'] ?? 'Não informado'}'),
                                Text(
                                    'Bairro: ${reciclado['endereco']['bairro'] ?? 'Não informado'}'),
                              ],
                              Text(
                                  'DocID: ${reciclado['userId'] ?? 'Não informado'}'),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 46, 50, 46),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 40),
            label: 'Área de Coleta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 40),
            label: 'Ver Itens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 40),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
