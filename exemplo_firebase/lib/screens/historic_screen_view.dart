import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/controllers/historic_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/profile_screen_view.dart';
import 'package:exemplo_firebase/screens/pontuacao_screen.dart';
import 'package:exemplo_firebase/screens/intern_screen_view.dart';
import 'package:intl/intl.dart';

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
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const HomePage(),
    const HistoricScreenView(),
    const RankingPage(),
    const ProfileScreen(),
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

  IconData _getIconForStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'em processo':
        return Icons.hourglass_bottom;
      case 'concluído':
        return Icons.check_circle;
      case 'Pendente':
        return Icons.pending;
      default:
        return Icons.help_outline;
    }
  }

  Color _getColorForStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'em processo':
        return Colors.orange;
      case 'concluído':
        return Colors.green;
      case 'Pendente':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatarData(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final DateTime dateTime =
        timestamp.toDate(); // Converte Timestamp para DateTime
    final DateFormat formatter = DateFormat('dd/MM/yyyy'); // Formato desejado
    return formatter.format(dateTime); // Retorna a data formatada
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF5E6CC), Color(0xFFF1D9B4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Fundo transparente para o gradiente aparecer
        appBar: CustomAppBar(user: user, showBackButton: true),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(),
                child: Image.asset(
                  'assets/folhas.png',
                  width: size.width,
                  height: size.height * 0.3, // Ajuste opcional para o fundo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                  String status = data['status'] ?? 'N/A';
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: size.height * 0.02),
                                    child: Card(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255), // Cor de fundo
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
                                                'assets/img_product.png',
                                                width: size.width * 0.2,
                                                height: size.width * 0.2,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.03),
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
                                                      height:
                                                          size.width * 0.02),
                                                  Text(
                                                    'Quantidade: ${data['qtd'] ?? 'N/A'}',
                                                    style: const TextStyle(
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.width * 0.02),
                                                  Text(
                                                    'Status: ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: _getColorForStatus(
                                                          status),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.width * 0.02),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        _getIconForStatus(
                                                            status),
                                                        size: 20,
                                                        color:
                                                            _getColorForStatus(
                                                                status),
                                                      ),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.02),
                                                      Text(
                                                        status,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              _getColorForStatus(
                                                                  status),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.width * 0.02),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        _getIconForStatus(
                                                            status),
                                                        size: 20,
                                                        color:
                                                            _getColorForStatus(
                                                                status),
                                                      ),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.02),
                                                      Text(
                                                        'Data: ${_formatarData(data['data_coleta'])}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.width * 0.02),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.wind_power,
                                                          size: 20,
                                                          color: Colors.amber),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.02),
                                                      Text(
                                                        'XP: ${(data['xp_ganho'])}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
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
      ),
    );
  }
}
