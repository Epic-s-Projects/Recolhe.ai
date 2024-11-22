import 'package:exemplo_firebase/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../controllers/user_data.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService _authService = new AuthService();
  final user = UserSession();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6BEA8),
      ),
      body: Column(
        children: [
          // Card
          Expanded(
            child: Container(
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
                    child: user.imagem!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(user.imagem!,
                                fit: BoxFit.cover, width: 300, height: 300))
                        : const Icon(Icons.person,
                            size: 50, color: Color(0xFF7B2CBF)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name!,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Informações com ícones
                  infoTile(Icons.email, user.email!),
                  infoTile(Icons.person, user.cpf!),
                  infoTile(Icons.location_on,
                      'R. Catatu dos Santos\nBarbados\n1090\n13486-229'),
                  const SizedBox(height: 20),
                  // Botão de sair
                  ElevatedButton(
                    onPressed: () async {
                      await _authService
                          .signOut(); // Chama o método para fazer logout.
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) =>
                              false); // Redireciona para a página de login.
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
