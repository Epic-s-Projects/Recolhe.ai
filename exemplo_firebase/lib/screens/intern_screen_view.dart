import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 209, 186),
        elevation: 0,
        title: const Text(
          'Olá João!',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 56, 128, 59)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 20.0), // Adicionando espaço à direita
            child: IconButton(
              icon: const Icon(Icons.person, size: 40, color: Colors.white),
              onPressed: () {
                // Ação ao clicar no ícone
              },
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

            // Semana com os dias
            _buildWeekDays(),

            const SizedBox(height: 30),

            // Imagem e texto principal
            Expanded(
              child: Center(
                child: Column(
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
                        // Ação do botão
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(149, 5, 23, 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon:
                      const Icon(Icons.add, color: Colors.white, size: 20),
                      label: const Text(
                        'Realize sua coleta',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 50), // Tamanho ajustado
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 50), // Tamanho ajustado
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 50), // Tamanho ajustado
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag, size: 50), // Tamanho ajustado
          label: 'Loja',
        ),
      ],
    );
  }
}