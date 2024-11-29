import 'package:exemplo_firebase/screens/profile_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'historic_screen_view.dart';
import 'intern_screen_view.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late Future<List<Map<String, dynamic>>> _rankingData;
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _rankingData = fetchUserXpData();
  }

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

  Future<List<Map<String, dynamic>>> fetchUserXpData() async {
    List<Map<String, dynamic>> usersWithXp = [];

    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        String name = userData['nome'] ?? 'Usuário';
        String photo = userData['imagem'] ?? 'assets/default_profile.jpg';

        QuerySnapshot recicladoSnapshot = await userDoc.reference.collection('reciclado').get();

        int totalXp = recicladoSnapshot.docs.fold<int>(
          0,
              (previousValue, recicladoDoc) {
            final data = recicladoDoc.data() as Map<String, dynamic>;
            return data['status'] == 'Concluído'
                ? previousValue + ((data['xp_ganho'] as num?)?.toInt() ?? 0)
                : previousValue;
          },
        );

        usersWithXp.add({
          'nome': name,
          'imagem': photo,
          'xp_ganho': totalXp,
        });
      }

      usersWithXp.sort((a, b) => b['xp_ganho'].compareTo(a['xp_ganho']));
    } catch (e) {
      print('Erro ao buscar dados de XP: $e');
    }

    return usersWithXp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ranking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _rankingData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhum dado encontrado',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final users = snapshot.data!;
              return Column(
                children: [
                  _buildTopThreeSection(users.take(3).toList()),
                  Expanded(
                    child: _buildRemainingRanking(users.skip(3).toList()),
                  ),
                ],
              );
            },
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

  Widget _buildTopThreeSection(List<Map<String, dynamic>> topThree) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumUser(
            user: topThree.length > 1 ? topThree[1] : null,
            height: 140,
            rank: 2,
          ),
          _buildPodiumUser(
            user: topThree.isNotEmpty ? topThree[0] : null,
            height: 180,
            rank: 1,
            isFirst: true,
          ),
          _buildPodiumUser(
            user: topThree.length > 2 ? topThree[2] : null,
            height: 100,
            rank: 3,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildPodiumUser({
    required Map<String, dynamic>? user,
    required double height,
    required int rank,
    bool isFirst = false,
  }) {
    if (user == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _getRankColor(rank),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: user['imagem'].startsWith('http')
                      ? NetworkImage(user['imagem']) as ImageProvider
                      : AssetImage(user['imagem']),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _getRankColor(rank),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Text(
                  '$rank°',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            user['nome'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            '${user['xp_ganho']} XP',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isFirst)
            Icon(
              Icons.emoji_events,
              color: Colors.amber.shade600,
              size: 40,
            ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.shade600;
      case 2:
        return Colors.grey.shade500;
      case 3:
        return Colors.brown.shade400;
      default:
        return Colors.green.shade700;
    }
  }

  Widget _buildRemainingRanking(List<Map<String, dynamic>> remainingRanking) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: remainingRanking.length,
        itemBuilder: (context, index) {
          final user = remainingRanking[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    backgroundImage: user['imagem'].startsWith('http')
                        ? NetworkImage(user['imagem']) as ImageProvider
                        : AssetImage(user['imagem']),
                    radius: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      '${index + 4}°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                user['nome'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green.shade900,
                ),
              ),
              trailing: Text(
                '${user['xp_ganho']} XP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                  fontSize: 16,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
}