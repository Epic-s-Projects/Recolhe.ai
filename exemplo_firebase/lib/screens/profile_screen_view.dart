import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/service/auth_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {


  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService _authService = AuthService();
  final user = UserSession();

  @override
  Widget build(BuildContext context) {
    // Obter as dimensões da tela
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(user: user,showBackButton: true, ),
      extendBodyBehindAppBar: true, // Faz o AppBar sobrepor o conteúdo
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Caminho da imagem
            fit: BoxFit.cover, // Faz a imagem ocupar toda a tela
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80), // Espaço para o AppBar
              // Avatar e Nome
              CircleAvatar(
                radius: screenWidth * 0.2, // Tamanho do avatar responsivo
                backgroundColor: Colors.white,
                child: user.imagem!.isNotEmpty
                    ? ClipOval(
                  child: Image.network(
                    user.imagem!,
                    fit: BoxFit.cover,
                    width: screenWidth * 0.4, // Responsivo
                    height: screenWidth * 0.4, // Responsivo
                  ),
                )
                    : const Icon(
                  Icons.person,
                  size: 50,
                  color: Color(0xFF7B2CBF),
                ),
              ),
              Text(
                user.name!,
                style: TextStyle(
                  fontSize: screenWidth * 0.08, // Responsivo
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              // Informações com ícones
              infoTile(Icons.email, user.email!),
              infoTile(Icons.person, user.cpf!),
              infoTile(
                Icons.location_on,
                'R. Catatu dos Santos\nBarbados\n1090\n13486-229',
              ),
              const SizedBox(height: 20), // Espaçamento antes do botão
              ElevatedButton(
                onPressed: () async {
                  await _authService.signOut(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.2,
                    vertical: screenHeight * 0.02,
                  ),
                ),
                child: const Text(
                  'Sair do aplicativo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 50),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color:
                Colors.grey.shade800.withOpacity(0.8), // Opacidade no fundo
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const Icon(Icons.edit, color: Colors.grey),
        ],
      ),
    );
  }
}