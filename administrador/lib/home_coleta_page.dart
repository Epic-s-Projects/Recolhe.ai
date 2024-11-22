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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4D6A5), // Cor superior
              Color(0xFFF4A261), // Cor inferior
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Olá, João!',
                    style: TextStyle(
                      color: Color(0xFF052E05),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 18,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
            ),

            // Calendar
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

            // Card com informações dinâmicas
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
                    Spacer(),
                    // Bottom Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1A1D10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Realize sua coleta',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF109410),
        unselectedItemColor: Colors.grey,
        items: [
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
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}