import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6BEA8),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Card
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE6BEA8), // Background da página principal
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Avatar e Nome
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.person,
                        size: 50, color: Color(0xFF7B2CBF)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "João Silva", // Nome fictício
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Informações com ícones
                  infoTile(Icons.email, "joao.silva@email.com"),
                  infoTile(Icons.person, "123.456.789-00"),
                  infoTile(Icons.location_on,
                      'R. Catatu dos Santos\nBarbados\n1090\n13486-229'),
                  const SizedBox(height: 20),
                  // Botão de sair
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 20),
                    ),
                    child: const Text(
                      'Sair do aplicativo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22, // Alteração do tamanho da fonte
                      ),
                    ),
                  ),
                ],
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 40), // Tamanho ajustado
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 40), // Tamanho ajustado
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 40), // Tamanho ajustado
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, size: 40), // Tamanho ajustado
            label: 'Loja',
          ),
        ],
      ),
    );
  }

  Widget infoTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 50),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(width: 25),
          Icon(Icons.edit, color: Colors.grey),
        ],
      ),
    );
  }
}
