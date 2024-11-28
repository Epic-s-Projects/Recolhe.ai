import 'package:flutter/material.dart';
import 'historic_screen_view.dart';
import 'intern_screen_view.dart';
import 'profile_screen_view.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int _selectedIndex = 2; // Define o índice inicial para esta página

  // Simulação das páginas (substitua com as suas páginas reais)
  final List<Widget> _pages = [
    HomePage(),
    HistoricScreenView(),
    RankingPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      // Navegação para a página selecionada
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ranking = [
      {'name': 'João', 'points': 150, 'image': 'assets/profile1.jpg'},
      {'name': 'Maria', 'points': 120, 'image': 'assets/profile2.jpg'},
      {'name': 'Pedro', 'points': 110, 'image': 'assets/profile3.jpg'},
      {'name': 'Ana', 'points': 100, 'image': 'assets/profile4.jpg'},
      {'name': 'Lucas', 'points': 90, 'image': 'assets/profile5.jpg'},
    ];

    return Scaffold(
      backgroundColor: Color(0xFFE4D9C4), // Cor de fundo (marrom claro)
      appBar: AppBar(
        backgroundColor: Color(0xFF1B5E20), // Tom de verde
        centerTitle: true,
        title: Text('Ranking Geral'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ranking Geral',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20), // Verde para o título
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: ranking.length,
                itemBuilder: (context, index) {
                  bool isTopThree = index < 3; // Verifica se é um dos três primeiros

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isTopThree
                            ? Color(0xFF1B5E20) // Verde para o top 3
                            : Color(0xFFE4D9C4), // Marrom claro
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(ranking[index]['image']),
                          radius: 30,
                        ),
                        title: Text(
                          ranking[index]['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isTopThree ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          'Pontos: ${ranking[index]['points']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: isTopThree ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        trailing: isTopThree
                            ? Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 30,
                        )
                            : null,
                      ),
                    ),
                  );
                },
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