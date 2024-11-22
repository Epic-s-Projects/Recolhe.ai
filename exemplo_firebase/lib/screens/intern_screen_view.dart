import 'package:exemplo_firebase/screens/profile_screen_view.dart';
import 'package:exemplo_firebase/screens/selection_screen_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String cpf;
  final String email;
  final String imagem;

  const HomePage({
    super.key,
    required this.name,
    required this.imagem,
    required this.cpf,
    required this.email,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCards = false; // Controle para exibir imagem ou cards
  int _selectedIndex = 0; // Controle para identificar a aba selecionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 209, 186),
        elevation: 0,
        title: Text(
          'Olá, ${widget.name}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 56, 128, 59),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _navigateToProfile(),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: widget.imagem.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        widget.imagem,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    )
                  : const Icon(Icons.person,
                      size: 30, color: Color(0xFF7B2CBF)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildWeekDays(),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: showCards ? _buildCards() : _buildImageAndText(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  void _onBottomNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Mantém o usuário na HomePage
        break;
      case 1:
        _navigateToProfile();
        break;
      case 2:
        _navigateToSelectionScreen();
        break;
      case 3:
        // Adicionar navegação futura para a Loja
        break;
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          name: widget.name,
          email: widget.email,
          cpf: widget.cpf,
          imagem: widget.imagem,
        ),
      ),
    );
  }

  void _navigateToSelectionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionScreenView(),
      ),
    );
  }

  Widget _buildImageAndText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/banner_inicial.png',
          height: 400,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20),
        const Text(
          'Você ainda não realizou nenhuma coleta!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
        ElevatedButton.icon(
          onPressed: _navigateToSelectionScreen,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(149, 5, 23, 5),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
          label: const Text(
            'Realize sua coleta',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCards() {
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) => Card(
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        color: const Color.fromRGBO(218, 194, 162, 1),
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/folhas2.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produto ${index + 1}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'DATA DE Criação\nDATA DE COLETA',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.add,
                color: Colors.green,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDays() {
    final List<Map<String, dynamic>> days = [
      {"day": "S", "color": Colors.blue},
      {"day": "T", "color": Colors.grey},
      {"day": "Q", "color": Colors.grey},
      {"day": "Q", "color": Colors.orange},
      {"day": "S", "color": Colors.grey},
      {"day": "S", "color": Colors.grey},
      {"day": "D", "color": Colors.grey},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(16, 148, 16, 1),
        borderRadius: BorderRadius.circular(90),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days
            .map((day) => CircleAvatar(
                  radius: 20,
                  backgroundColor: day['color'],
                  child: Text(
                    day['day'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 46, 50, 46),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onBottomNavigationTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 30),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 30),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag, size: 30),
          label: 'Loja',
        ),
      ],
    );
  }
}
