import 'package:flutter/material.dart';

class HomeColetaPage extends StatefulWidget {
  @override
  _HomeColetaPageState createState() => _HomeColetaPageState();
}

class _HomeColetaPageState extends State<HomeColetaPage> {
  bool showProductInfo = false; // Controla o estado do card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4A261), // Cor do AppBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retorna para a página anterior
          },
        ),
      ),
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/fundoHome.png',
              fit: BoxFit.cover,
            ),
          ),
          // Conteúdo da página
          Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF109410), Color(0xFF052E05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Olá, João!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // A cor base é substituída pelo gradiente
                        ),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person, // Ícone de usuário
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Espaçamento maior entre o header e o calendário
              const SizedBox(height: 32),

              // Calendário
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCalendarItem('S', Color(0xFF5D6DFF)),
                    _buildCalendarItem('T', Color(0xFF109410)),
                    _buildCalendarItem('Q', Color(0xFFC59A64)),
                    _buildCalendarItem('Q', Color(0xFF109410)),
                    _buildCalendarItem('S', Color(0xFF109410)),
                    _buildCalendarItem('S', Color(0xFF109410)),
                    _buildCalendarItem('D', Color(0xFF109410)),
                  ],
                ),
              ),

              // Espaçamento maior entre o calendário e os cards
              const SizedBox(height: 24),

              // Cards com informações dinâmicas
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showProductInfo = !showProductInfo; // Alterna o estado
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                            title: Text(
                              showProductInfo ? 'Produto' : 'CASA',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              showProductInfo
                                  ? 'DATA DE Criação\nDATA DE COLETA'
                                  : 'Endereço\nPessoa',
                            ),
                            trailing: Icon(Icons.close, color: Colors.black),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Bottom Button
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF109410),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarItem(String label, Color color) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
