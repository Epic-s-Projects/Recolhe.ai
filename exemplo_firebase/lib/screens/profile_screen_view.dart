import 'package:exemplo_firebase/screens/pontuacao_screen.dart';
import 'package:flutter/material.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cadastro_endereco_screen.dart';
import 'historic_screen_view.dart';
import 'intern_screen_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final user = UserSession();
  int _selectedIndex = 3;
  Map<String, String> _address = {};

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('endereco')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          _address = {
            'cep': data['cep'] ?? 'CEP não informado',
            'rua': data['rua'] ?? 'Rua não informada',
            'bairro': data['bairro'] ?? 'Bairro não informado',
            'numero': data['numero'] ?? 'Número não informado',
          };
        });
      } else {
        setState(() {
          _address = {
            'cep': 'Endereço não cadastrado',
            'rua': '',
            'bairro': '',
            'numero': '',
          };
        });
      }
    } catch (e) {
      setState(() {
        _address = {
          'cep': 'Erro ao carregar endereço',
          'rua': '',
          'bairro': '',
          'numero': '',
        };
      });
    }
  }

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

  final List<Widget> _pages = [
    HomePage(),
    HistoricScreenView(),
    RankingPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(37), // Define a altura desejada (50 é um exemplo)
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false, // Remove a seta de voltar
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        user.imagem != null && user.imagem!.isNotEmpty
                            ? NetworkImage(user.imagem!)
                            : null,
                    child: user.imagem == null || user.imagem!.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.green.shade700,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white, size: 20),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Nome e Botão Editar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name!,
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: Colors.green.shade700, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Informações de Perfil
              _buildInfoCard(
                icon: Icons.email,
                title: 'E-mail',
                content: user.email!,
              ),
              _buildInfoCard(
                icon: Icons.person,
                title: 'CPF',
                content: user.cpf!,
              ),
              _buildAddressCard(
                context: context,
                icon: Icons.location_on,
                title: 'Endereço',
                content:
                    '${_address['rua']}, ${_address['numero']}\n${_address['bairro']}\nCEP: ${_address['cep']}',
              ),

              const SizedBox(height: 32),

              // Botão Sair
              ElevatedButton(
                onPressed: () => _authService.signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Sair do aplicativo',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade700, size: 32),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.green.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading:
            Icon(Icons.location_on, color: Colors.green.shade700, size: 32),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.green.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          content,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.green.shade700, size: 20),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ModernAddressRegistrationPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
