import 'package:flutter/material.dart';
import 'historic_screen_view.dart';
import 'intern_screen_view.dart';
import 'profile_screen_view.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int _selectedIndex = 2;

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
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> ranking = [
      {'name': 'João', 'points': 150, 'image': 'assets/profile1.jpg'},
      {'name': 'Maria', 'points': 120, 'image': 'assets/profile2.jpg'},
      {'name': 'Pedro', 'points': 110, 'image': 'assets/profile3.jpg'},
      {'name': 'Ana', 'points': 100, 'image': 'assets/profile4.jpg'},
      {'name': 'Lucas', 'points': 90, 'image': 'assets/profile5.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(228, 243, 195, 129),
        title: const Text(
          'Ranking Geral',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/background.png'),
                radius: 20,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // Opacidade preta.
          ),
          Column(
            children: [
              _buildTopThreeSection(ranking.take(3).toList()),
              Expanded(
                child: _buildRemainingRanking(ranking.skip(3).toList()),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTopThreeSection(List<Map<String, dynamic>> topThree) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      height: 250,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPodiumUser(
                  user: topThree[1], height: 140, color: Colors.grey.shade300),
              _buildPodiumUser(
                  user: topThree[0],
                  height: 90,
                  color: Colors.yellow.shade200,
                  isFirst: true),
              _buildPodiumUser(
                  user: topThree[2], height: 100, color: Colors.brown.shade200),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumUser({
    required Map<String, dynamic> user,
    required double height,
    required Color color,
    bool isFirst = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage(user['image']),
          ),
          const SizedBox(height: 8),
          Text(
            user['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            '${user['points']} pts',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
          if (isFirst)
            const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 50,
            ),
          Text(
            isFirst
                ? '1º'
                : height == 140
                    ? '2º'
                    : '3º',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingRanking(List<Map<String, dynamic>> remainingRanking) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: remainingRanking.length,
      itemBuilder: (context, index) {
        final user = remainingRanking[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 192, 203, 193),
                Color.fromARGB(255, 167, 199, 168)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(172, 165, 214, 167).withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(125, 0, 0, 0),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(user['image']),
                radius: 20,
              ),
            ),
            title: Text(
              user['name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            subtitle: Text(
              'Ranking ${index + 4}',
              style: TextStyle(
                color: Colors.green.shade700,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '${user['points']} pts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
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
    );
  }
}
