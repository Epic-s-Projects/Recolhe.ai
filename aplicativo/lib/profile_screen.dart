import 'package:flutter/material.dart';

void main() {
  runApp(const PerfilApp());
}

class PerfilApp extends StatelessWidget {
  const PerfilApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PerfilPage(),
      theme: ThemeData(
        primaryColor: Colors.blue, // Defina uma cor primária aqui
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blue, // Cor de fundo da barra de navegação
          selectedItemColor: Colors.white, // Cor do ícone selecionado
          unselectedItemColor: Colors.black, // Cor do ícone não selecionado
        ),
      ),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6BEA8),
        title: Icon(Icons.add_circle),
      ),
      body: Column(
        children: [
          // Card
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE6BEA8), // Background da página principal
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Avatar e Nome
                  CircleAvatar(
                    radius: 80,
                    // backgroundImage: AssetImage('assets/avatar.png'), // Altere para sua imagem
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'João Henrique de Sousa',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Informações com ícones
                  infoTile(Icons.email, 'joao.henrique@gmail.com'),
                  infoTile(Icons.cake, '123.456.789.01'),
                  infoTile(Icons.location_on, 'R. Catatu dos Santos\nBarbados\n1090\n13486-229'),
                  const SizedBox(height: 20),
                  // Botão de sair
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
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
          ),
          // Barra de navegação
          BottomNavigationBar(
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
              )
            ],
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
