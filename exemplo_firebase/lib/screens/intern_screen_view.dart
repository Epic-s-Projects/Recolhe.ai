import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/screens/historic_screen_view.dart';
import 'package:exemplo_firebase/screens/oil_register_screen.dart';
import 'package:exemplo_firebase/screens/pontuacao_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/user_data.dart';
import 'profile_screen_view.dart';
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.009),
                  _buildWeekDays(screenWidth),
                  SizedBox(height: screenHeight * 0.009),
                  SizedBox(
                    height: screenHeight * 0.72,
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
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Assistente ativado!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 69, 101),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.07,
                      MediaQuery.of(context).size.width * 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.04),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 4,
                    ),
                  ),
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.smart_toy_outlined,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                      'IA',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .shimmer(
                    duration: 1500.ms, color: Colors.white.withOpacity(0.3))
                .then()
                .shake(duration: 500.ms, delay: 2000.ms),
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
    );
  }

  Widget _buildImageAndText(double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/banner_inicial.png',
          height: screenHeight * 0.2,
          fit: BoxFit.cover,
        ),
        SizedBox(height: screenHeight * 0.02),
        const Text(
          'Você ainda não realizou nenhuma coleta!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenHeight * 0.06),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => SelectionScreenView(),
                  builder: (context) => const OilRegisterScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF056517),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
          ).animate().scale(duration: 100.ms).fadeIn(),
          //     key: const Icon(Icons.add, color: Colors.white, size: 28),
          //     label: const Text(
          //       'Realize sua coleta',
          //       style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ).animate().scale(duration: 300.ms).fadeIn(),
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

    // Mapeamento de dias da semana para abreviações
    final weekdayNames = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.03, horizontal: screenWidth * 0.02),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF2E7D32),
                Color(0xFF388E3C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Cabeçalho com nomes dos dias
              Padding(
                padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekdayNames
                      .map((name) => Text(
                            name,
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.03,
                            ),
                          ))
                      .toList(),
                ),
              ),
              // Grid de dias
              GridView.builder(
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
                  bool isToday = _isDateToday(currentDay);
                  bool isSelected = _isDateSelected(currentDay);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = currentDay;
                        isCalendarExpanded = !isCalendarExpanded;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getDateColor(isToday, isSelected),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${currentDay.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _getTextColor(isToday, isSelected),
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          if (isToday)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
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

    // Nome dos meses em português
    final monthNames = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return Container(
      margin: EdgeInsets.only(top: screenWidth * 0.03),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título do mês
          Padding(
            padding: EdgeInsets.only(bottom: screenWidth * 0.03),
            child: Text(
              '${monthNames[now.month - 1]} ${now.year}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
          GridView.builder(
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
              bool isToday = _isDateToday(currentDay);
              bool isSelected = _isDateSelected(currentDay);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = currentDay;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getDateColor(isToday, isSelected),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${currentDay.day}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTextColor(isToday, isSelected),
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                      if (isToday)
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

// Funções auxiliares para estilização
  bool _isDateToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isDateSelected(DateTime date) {
    return date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
  }

  Color _getDateColor(bool isToday, bool isSelected) {
    if (isSelected) return Colors.blue;
    if (isToday) return Colors.green.withOpacity(0.2);
    return Colors.transparent;
  }

  Color _getTextColor(bool isToday, bool isSelected) {
    if (isSelected) return Colors.white;
    if (isToday) return const Color.fromARGB(255, 0, 208, 76);
    return Colors.white;
  }

  String _formatarData(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final DateTime dateTime =
        timestamp.toDate(); // Converte Timestamp para DateTime
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
                                    .fadeIn(duration: 100.ms)
                                    .scale(duration: 100.ms),
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
                        .slideX(duration: 100.ms)
                        .then()
                        .shake(duration: 100.ms),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => SelectionScreenView(),
                  builder: (context) => const OilRegisterScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF056517),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
          ).animate().scale(duration: 100.ms).fadeIn(),
          //     key: const Icon(Icons.add, color: Colors.white, size: 28),
          //     label: const Text(
          //       'Realize sua coleta',
          //       style: TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ).animate().scale(duration: 300.ms).fadeIn(),
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
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 10,
          title: Row(
            children: [
              Icon(
                Icons.recycling,
                color: const Color(0xFF1B5E20),
                size: screenWidth * 0.08,
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                'Detalhes da Coleta',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                  fontSize: screenWidth * 0.05,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFF388E3C), width: 2),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Tipo', data['tipo'] ?? 'Não especificado',
                    Icons.category, const Color(0xFF388E3C)),
                _buildDetailRow('Quantidade', '${data['qtd'] ?? 'N/A'} ml',
                    Icons.scale, const Color(0xFF1976D2)),
                _buildDetailRow(
                    'Status',
                    data['status'] ?? 'Não definido',
                    _getIconForStatus(data['status']),
                    _getColorForStatus(data['status'])),
                _buildDetailRow(
                    'Data de Atualização',
                    data['dataAtualizacao'] ?? 'Desconhecido',
                    Icons.calendar_month,
                    const Color(0xFF9E9E9E)),
                if (data['observacoes'] != null)
                  _buildDetailRow('Observações', data['observacoes'],
                      Icons.comment, const Color(0xFF0288D1)),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Color(0xFF388E3C)),
                  label: const Text(
                    'Fechar',
                    style: TextStyle(
                      color: Color(0xFF388E3C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // if (data['status'] == 'Em processo')
                //   ElevatedButton.icon(
                //     onPressed: () {
                //       // Ação para acompanhar a coleta
                //       Navigator.of(context).pop();
                //       // Adicione aqui a navegação para tela de acompanhamento
                //     },
                //     icon: const Icon(Icons.track_changes, color: Colors.white),
                //     label: const Text(
                //       'Acompanhar',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF1B5E20),
                //     ),
                //   ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
