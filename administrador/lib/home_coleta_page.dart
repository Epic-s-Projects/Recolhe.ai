import 'package:flutter/material.dart';

class HomeColetaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            // Address card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              productName: 'Produto',
                              creationDate: 'DATA DE Criação',
                              collectionDate: 'DATA DE COLETA',
                            ),
                          ),
                        );
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
                            color: Colors.grey[300], // Placeholder for the image
                            child: Icon(Icons.image, color: Colors.grey),
                          ),
                          title: Text(
                            'CASA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('Endereço\nPessoa'),
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

class ProductDetailsScreen extends StatelessWidget {
  final String productName;
  final String creationDate;
  final String collectionDate;

  ProductDetailsScreen({
    required this.productName,
    required this.creationDate,
    required this.collectionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF109410),
        title: Text('Detalhes do Produto'),
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
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Data de Criação: $creationDate',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Data de Coleta: $collectionDate',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
