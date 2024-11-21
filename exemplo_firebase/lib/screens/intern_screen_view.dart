import 'package:exemplo_firebase/screens/profile_screen_view.dart';
import 'package:exemplo_firebase/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String name;
  final String cpf;
  final String email;
  final String imagem;

  const HomePage(
      {super.key,
      required this.name,
      required this.imagem,
      required this.cpf,
      required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  bool showCards = false; // Controle para exibir imagem ou cards

  @override
  void initState() {
    super.initState();
  }

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
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: widget.imagem.isNotEmpty
                ? ClipOval(
                    child: Image.network(widget.imagem,
                        fit: BoxFit.cover, width: 50, height: 100))
                : const Icon(Icons.person, size: 80, color: Color(0xFF7B2CBF)),
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
                child: showCards
                    ? _buildCards() // Exibe os cards se o botão for pressionado
                    : _buildImageAndText(), // Exibe a imagem e o texto principal
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
          onPressed: () {
            setState(() {
              showCards = true; // Altera o estado para exibir os cards
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(149, 5, 23, 5),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
          label: const Text(
            'Realize sua coleta',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildCards() {
    return ListView(
      children: List.generate(
        3, // Número de cards
        (index) => Card(
          margin: const EdgeInsets.symmetric(vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/folhas2.png', // Substitua pela imagem real
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Produto ${index + 1}'),
            subtitle: const Text('DATA DE Criação\nDATA DE COLETA'),
            trailing: const Icon(Icons.add, color: Colors.green, size: 30),
          ),
        ),
      ),
    );
  }

  // Widget para os dias da semana
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
                  radius: 20, // Aumentado para maior visibilidade
                  backgroundColor: day['color'],
                  child: Text(
                    day['day'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Tamanho ajustado para proporcionalidade
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // Widget para a BottomNavigationBar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 46, 50, 46),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                    name: widget.name,
                    email: widget.email,
                    cpf: widget.cpf,
                    imagem: widget.imagem),
              ),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 50), // Ícone ajustado
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 50), // Ícone ajustado
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 50), // Ícone ajustado
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag, size: 50), // Ícone ajustado
          label: 'Loja',
        ),
      ],
    );
  }
}
