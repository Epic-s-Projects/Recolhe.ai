import 'package:exemplo_firebase/controllers/historic_controller.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/pontuacao_screen.dart';
import 'package:exemplo_firebase/screens/profile_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cadastro_endereco_screen.dart';
import 'intern_screen_view.dart';

class HistoricScreenView extends StatefulWidget {
  const HistoricScreenView({super.key});

  @override
  _HistoricScreenViewState createState() => _HistoricScreenViewState();
}

class _HistoricScreenViewState extends State<HistoricScreenView> {
  final HistoricController controller = HistoricController();
  List<Map<String, dynamic>> historicData = [];
  bool isLoading = true;
  final user = UserSession();
  int _selectedIndex = 1; // Define o índice inicial para esta página

  // Lista de páginas para alternância na barra de navegação
  final List<Widget> _pages = [
    HomePage(),
    HistoricScreenView(),
    RankingPage(),
    ProfileScreen(),
  ];

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
  void initState() {
    super.initState();
    fetchHistoricData();
  }

  Future<void> fetchHistoricData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        user.email = data['email'] ?? 'email@exemplo.com';
        user.name = data['nome'] ?? 'Usuário';
        user.cpf = data['cpf'] ?? '123';
        user.imagem = data['imagem'] ?? '';

        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.userId)
            .collection('reciclado')
            .get();

        setState(() {
          historicData = querySnapshot.docs.map((doc) => doc.data()).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar dados: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back, color: Colors.green, size: size.width * 0.08),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );// Volta para a página anterior
          },
        ),
        title: Text(
          'Olá, ${user.name}!',
          style: TextStyle(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: CircleAvatar(
              radius: size.width * 0.06,
              backgroundColor: Colors.white,
              child: (user.imagem!.isNotEmpty)
                  ? ClipOval(
                child: Image.network(
                  user.imagem!,
                  fit: BoxFit.cover,
                  width: size.width * 0.12,
                  height: size.width * 0.12,
                ),
              )
                  : const Icon(Icons.person, size: 30, color: Colors.green),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5E6CC), Color(0xFFF1D9B4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Substituindo o fundo original pelo novo layout
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(), // Ajusta a posição vertical
                child: Image.asset(
                  'assets/folhas.png',
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Conteúdo da tela (histórico e texto)
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Históricos",
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : historicData.isEmpty
                        ? Center(
                      child: Text(
                        "Nenhum histórico encontrado.",
                        style: TextStyle(
                          fontSize: size.width * 0.05,
                          color: Colors.black54,
                        ),
                      ),
                    )
                        : ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05),
                      itemCount: historicData.length,
                      itemBuilder: (context, index) {
                        final data = historicData[index];
                        return Padding(
                          padding:
                          EdgeInsets.only(bottom: size.height * 0.02),
                          child: Card(
                            color:
                            const Color.fromRGBO(218, 194, 162, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding:
                              EdgeInsets.all(size.width * 0.04),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/folhas2.png',
                                      width: size.width * 0.2,
                                      height: size.width * 0.2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                      width: size.width * 0.03),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tipo: ${data['tipo'] ?? 'N/A'}',
                                          style: TextStyle(
                                            fontSize:
                                            size.width * 0.05,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                            height: size.width * 0.02),
                                        Text(
                                          'Quantidade: ${data['qtd'] ?? 'N/A'}',
                                          style: const TextStyle(
                                              fontSize: 14),
                                        ),
                                        SizedBox(
                                            height: size.width * 0.02),
                                        Text(
                                          'Status: ${data['status'] ?? 'N/A'}',
                                          style: const TextStyle(
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            icon: Icon(Icons.history, size: 40),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist, size: 40),
            label: 'Pontuação',
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



