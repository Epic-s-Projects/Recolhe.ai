import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/screens/historic_screen_view.dart';
import 'package:exemplo_firebase/screens/pontuacao_screen.dart';
import 'package:flutter/material.dart';
import '../controllers/user_data.dart';
import 'profile_screen_view.dart';
import 'selection_screen_view.dart';

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
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    color: const Color.fromRGBO(218, 194, 162, 1),
                    margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/img_product.png',
                              width: screenWidth * 0.09,
                              height: screenWidth * 0.09,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tipo: ${data['tipo'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: screenWidth * 0.02),
                                Text(
                                  'Quantidade: ${data['qtd'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectionScreenView(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(149, 5, 23, 5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 30),
          label: const Text(
            'Realize sua coleta',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
