import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/screens/historic_screen_view.dart';
import 'package:exemplo_firebase/screens/pontuacao_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/user_data.dart';
import 'profile_screen_view.dart';
import 'selection_screen_view.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Para animações (adicionar no pubspec.yaml).

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCards = false; // Controle para exibir imagem ou cards
  final user = UserSession();
  DateTime selectedDate = DateTime.now(); // Data selecionada no calendário
  bool isCalendarExpanded = false; // Estado do calendário expandido

  int _selectedIndex = 0; // Define o índice inicial para esta página

  // Lista de páginas para alternância na barra de navegação
  final List<Widget> _pages = [
    const HomePage(),
    const HistoricScreenView(),
    RankingPage(),
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
    fetchUserData(); // Carrega os dados do usuário no início
  }

  Future<void> fetchUserData() async {
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

        final recicladoCollection = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.userId)
            .collection('reciclado')
            .where('status', isEqualTo: 'Em processo')
            .get();

        setState(() {
          showCards = recicladoCollection.docs.isNotEmpty;
        });
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      appBar: CustomAppBar(user: UserSession(), showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildWeekDays(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                height: screenHeight * 0.69,
                child: Center(
                  child: showCards
                      ? _buildCards(screenWidth)
                      : _buildImageAndText(screenWidth, screenHeight),
                ),
              ),
            ],
          ),
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

  Widget _buildImageAndText(double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Imagem
        Image.asset(
          'assets/banner_inicial.png',
          height: screenHeight * 0.2,
          fit: BoxFit.cover,
        ),
        SizedBox(height: screenHeight * 0.02),

        // Texto
        const Text(
          'Você ainda não realizou nenhuma coleta!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenHeight * 0.06),

        // ElevatedButton
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0009),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectionScreenView(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF056517),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            label: const Text(
              'Realize sua coleta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ).animate().scale(duration: 300.ms).fadeIn(),
        ),
      ],
    );
  }


  Widget _buildWeekDays(double screenWidth) {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday));

    List<DateTime> weekDays = List.generate(7, (index) {
      return firstDayOfWeek.add(Duration(days: index));
    });

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 1, 131, 34),
            borderRadius: BorderRadius.circular(15),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: screenWidth * 0.02,
              crossAxisSpacing: screenWidth * 0.02,
            ),
            itemCount: weekDays.length,
            itemBuilder: (context, index) {
              DateTime currentDay = weekDays[index];
              bool isToday = currentDay.day == now.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = currentDay;
                    isCalendarExpanded = !isCalendarExpanded;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentDay == selectedDate
                        ? Colors.blue
                        : Colors.transparent,
                  ),
                  child: Text(
                    '${currentDay.day}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday
                          ? const Color.fromARGB(255, 0, 255, 47)
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (isCalendarExpanded) _buildFullMonthCalendar(now, screenWidth),
      ],
    );
  }

  Widget _buildFullMonthCalendar(DateTime now, double screenWidth) {
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    List<DateTime> monthDays = List.generate(
      lastDayOfMonth.day,
          (index) => firstDayOfMonth.add(Duration(days: index)),
    );

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 1, 131, 34),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: screenWidth * 0.02,
          crossAxisSpacing: screenWidth * 0.02,
        ),
        itemCount: monthDays.length,
        itemBuilder: (context, index) {
          DateTime currentDay = monthDays[index];
          bool isToday = currentDay.day == now.day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = currentDay;
              });
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentDay == selectedDate
                    ? Colors.blue
                    : Colors.transparent,
              ),
              child: Text(
                '${currentDay.day}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: currentDay == selectedDate
                      ? Colors.white
                      : (isToday
                      ? const Color.fromARGB(255, 0, 208, 76)
                      : const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatarData(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final DateTime dateTime = timestamp.toDate(); // Converte Timestamp para DateTime
    final DateFormat formatter = DateFormat('dd/MM/yyyy'); // Formato desejado
    return formatter.format(dateTime); // Retorna a data formatada
  }


  Widget _buildCards(double screenWidth) {
    if (user.userId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.userId)
                .collection('reciclado')
                .where('status', isEqualTo: 'Em processo')
                // .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return _buildImageAndText(
                  screenWidth,
                  MediaQuery.of(context).size.height,
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  return Card(
                    color: const Color.fromARGB(255, 239, 239, 239),
                    margin: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.03,
                      horizontal: screenWidth * 0.01,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        // Ação ao clicar no card
                        _showDetailDialog(context, data);
                      },
                      hoverColor: const Color.fromARGB(255, 223, 209, 186),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 30.0),
                                child: Image.asset(
                                  _getImageForRecycleType(data['tipo']),
                                  width: screenWidth * 0.13,
                                  height: screenWidth * 0.13,
                                  fit: BoxFit.cover,
                                )
                                    .animate()
                                    .fadeIn(duration: 500.ms)
                                    .scale(duration: 500.ms),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['tipo'] ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: screenWidth * 0.02),
                                  Row(
                                    children: [
                                      Icon(Icons.scale,
                                          size: screenWidth * 0.04,
                                          color: Colors.green),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        'Quantidade: ${data['qtd'] ?? 'N/A'} ml',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenWidth * 0.02),
                                  Row(
                                    children: [
                                      Icon(
                                        _getIconForStatus(data['status']),
                                        size: screenWidth * 0.04,
                                        color:
                                        _getColorForStatus(data['status']),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        'Status: ${data['status'] ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: _getColorForStatus(
                                              data['status']),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),


                                  SizedBox(height: screenWidth * 0.02),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: screenWidth * 0.04,
                                        color: Color(0xFF9E9E9E),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        'Data: ${_formatarData(data['timestamp'])}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),




                                  // SizedBox(height: screenWidth * 0.02),
                                ],
                              ),
                            ),
                            // Icon(Icons.chevron_right, color: Colors.grey[400]),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .slideX(duration: 300.ms)
                        .then()
                        .shake(duration: 200.ms),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.0009),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectionScreenView(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF056517),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            label: const Text(
              'Realize sua coleta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ).animate().scale(duration: 300.ms).fadeIn(),
        ),
      ],
    );
  }

// Funções auxiliares para melhorar a interface
  String _getImageForRecycleType(String? type) {
    switch (type?.toLowerCase()) {
      case 'papel':
        return 'assets/papel.png';
      case 'plastico':
        return 'assets/plastico.png';
      case 'metal':
        return 'assets/metal.png';
      case 'vidro':
        return 'assets/vidro.png';
      default:
        return 'assets/img_product.png';
    }
  }

  IconData _getIconForStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'em processo':
        return Icons.hourglass_bottom;
      case 'concluído':
        return Icons.check_circle;
      case 'pendente':
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
      case 'pendente':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Cor de fundo suave
          title: const Text(
            'Detalhes da Coleta',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20), // Cor verde para o título
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
                color: Color(0xFF388E3C), width: 2), // Borda verde
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Tipo', data['tipo'] ?? 'N/A', Icons.category,
                  const Color(0xFF388E3C)),
              _buildDetailRow('Quantidade', '${data['qtd'] ?? 'N/A'} kg',
                  Icons.storage, const Color(0xFF1976D2)),
              _buildDetailRow('Status', data['status'] ?? 'N/A',
                  Icons.check_circle, const Color(0xFFFF9800)),
              _buildDetailRow(
                  'Data de Atualização',
                  data['dataAtualizacao'] ?? 'Desconhecido',
                  Icons.calendar_today,
                  const Color(0xFF9E9E9E)),
              if (data['observacoes'] != null)
                _buildDetailRow('Observações', data['observacoes'],
                    Icons.comment, const Color(0xFF0288D1)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Fechar',
                style: TextStyle(
                  color: Color(0xFF388E3C), // Cor verde para o botão
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color, // Cor para o título da linha
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color
                    .withOpacity(0.7), // Cor do valor com opacidade ajustada
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}