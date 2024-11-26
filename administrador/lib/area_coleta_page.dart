import 'package:flutter/material.dart';
import 'home_adm_page.dart';
import 'home_coleta_page.dart';
import 'profile_adm_page.dart';

class AreaColetaPage extends StatefulWidget {
  @override
  _AreaColetaPageState createState() => _AreaColetaPageState();
}

class _AreaColetaPageState extends State<AreaColetaPage> {
  bool showMapCard = false; // Controla se o card do mapa será exibido
  int _selectedIndex = 1; // Define o índice inicial para esta página

  // Lista de páginas para alternância na barra de navegação
  final List<Widget> _pages = [
    HomeAdmPage(),
    AreaColetaPage(),
    HomeColetaPage(),
    ProfileScreen(
      name: "João Silva",
      cpf: "123.456.789-00",
      email: "joao.silva@email.com",
      imagem: "", // Substitua por uma URL válida ou deixe vazio.
    ),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Fundo transparente
        elevation: 0, // Sem sombra
        automaticallyImplyLeading: false, // Remove qualquer botão de voltar automático
      ),
      extendBodyBehindAppBar: true, // Faz o conteúdo ocupar o espaço atrás do AppBar
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/fundoHome.png', // Caminho da imagem de fundo
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo da página
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                // Header com saudação e avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Olá, João!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/avatar.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                if (!showMapCard) ...[
                  // Exibição inicial antes de "Ver Mapa"
                  const Center(
                    child: Text(
                      'Aguardando entrada em área \nde coleta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF109410), Color(0xFF1AE91A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showMapCard = true; // Altera o estado para exibir o card
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Ver Mapa',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.location_pin,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                const Spacer(),
              ],
            ),
          ),
          if (showMapCard)
          // Card do mapa
            Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header do card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lixo de João!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              showMapCard = false; // Fechar o card
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Conteúdo do card
                    Row(
                      children: [
                        Icon(Icons.electrical_services, color: Colors.black),
                        const SizedBox(width: 8),
                        const Text('Eletrônico', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.oil_barrel, color: Colors.black),
                        const SizedBox(width: 8),
                        const Text('Óleo', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Botão Ver Local
                    ElevatedButton(
                      onPressed: () {
                        // Lógica do botão "Ver Local"
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'VER LOCAL',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
}
