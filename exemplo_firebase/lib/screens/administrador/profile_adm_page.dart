import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/administrador/endereco_page.dart';
import 'package:exemplo_firebase/screens/administrador/home_coleta_page.dart';
import 'package:exemplo_firebase/screens/administrador/reciclados_proximos.dart';
import 'package:exemplo_firebase/screens/profile_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:exemplo_firebase/service/auth_service.dart';

class ProfileScreenADM extends StatefulWidget {
  const ProfileScreenADM({super.key});

  @override
  State<ProfileScreenADM> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenADM> {
  final user = UserSession();
  final AuthService _authService = AuthService();
  int _selectedIndex = 3;
  String? _creationDate;

  @override
  void initState() {
    super.initState();
    fetchUserCreationDate().then((date) {
      setState(() {
        _creationDate = date;
      });
    });
  }

  Future<String> fetchUserCreationDate() async {
    final userLogado = FirebaseAuth.instance.currentUser;

    if (userLogado != null) {
      try {
        // Busca o documento do usuário no Firestore
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userLogado.uid)
            .get();

        // Verifica se o documento existe e contém dados
        if (userData.exists && userData.data() != null) {
          // Tenta recuperar o campo "createdAt"
          final creationTimestamp = userData['createdAt'];

          // Valida se o campo é do tipo Timestamp
          if (creationTimestamp is Timestamp) {
            final DateTime creationDate = creationTimestamp.toDate();
            return '${creationDate.day}/${creationDate.month}/${creationDate.year}';
          } else {
            throw Exception('Campo "createdAt" não é um Timestamp válido.');
          }
        } else {
          throw Exception('Usuário não encontrado no Firestore.');
        }
      } catch (e) {
        print('Erro ao buscar data de criação: $e');
        return 'Desconhecida';
      }
    } else {
      // Caso o usuário não esteja autenticado
      print('Nenhum usuário autenticado.');
      return 'Desconhecida';
    }
  }

  final List<Widget> _pages = [
    const NearbyItemsPage(),
    // AreaColetaPage(),
    EnderecosPage(),
    HomeColetaPage(),
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(37),
        // Define a altura desejada (50 é um exemplo)
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
                        icon: const Icon(Icons.edit,
                            color: Colors.white, size: 20),
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
                    user.name ??
                        'Nome não disponível', // Define um valor padrão
                    style: textTheme.headlineMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ) ??
                        TextStyle(
                          // Define um estilo padrão se headlineMedium for null
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize:
                              20, // Ajuste o tamanho da fonte conforme necessário
                        ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: Colors.green.shade700, size: 20),
                    onPressed: () {
                      // Adicione a lógica desejada para a ação do botão
                    },
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
              const SizedBox(height: 32),
              if (_creationDate != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Colors.green.shade700, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coletor desde',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _creationDate!,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

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
            icon: Icon(Icons.location_on, size: 40),
            label: 'Área de Coleta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 40),
            label: 'Ver Itens',
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
}
