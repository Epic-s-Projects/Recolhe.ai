import 'package:flutter/material.dart';
import 'package:testpaginas/Controller/TelaHistoricoController.dart';
import 'package:testpaginas/Controller/TelaQuantidadeController.dart';

class TelaHistoricoView extends StatelessWidget {
  final TelaHistoricoController controller = TelaHistoricoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Caminho da imagem
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Ícone de voltar
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.green, size: 50),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Avatar do usuário
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.png'), // Imagem do avatar
              radius: 35,
            ),
          ),
          // Texto de saudação
          Positioned(
            top: 50,
            left: 100,
            child: Text(
              "Olá, João!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          // Conteúdo principal
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Área principal com histórico
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Título da seção
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 50),
                        child: Text(
                          "Históricos",
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ),
                      // Área limitada para ScrollView
                      SizedBox(
                        height: 400, // Altura fixa do ScrollView
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Itens do histórico
                              HistoryCard(
                                date: "11/11/2024 - 13:56",
                                type: "Somente Eletrônico",
                                timeIcon: Icons.access_time, // Ícone de relógio
                                icon: Icons.delete,         // Ícone de lixo
                              ),
                              SizedBox(height: 20),
                              HistoryCard(
                                date: "02/12/2024 - 18:47",
                                type: "Eletrônico e Óleo",
                                timeIcon: Icons.access_time,
                                icon: Icons.recycling,      // Ícone de reciclagem
                              ),
                              SizedBox(height: 20),
                              // Adicione mais históricos aqui para testar a rolagem
                              for (int i = 0; i < 10; i++) ...[
                                HistoryCard(
                                  date: "02/12/2024 - 18:47",
                                  type: "Eletrônico e Óleo",
                                  timeIcon: Icons.access_time,
                                  icon: Icons.recycling,      // Ícone de reciclagem
                                ),
                                SizedBox(height: 20),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Barra de navegação inferior
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(0.8),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 45,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: '',
            ),
          ],
          onTap: (index) {
            controller.handleBottomNavTap(context, index);
          },
        ),
      ),
    );
  }
}

// Widget para os cartões de histórico
class HistoryCard extends StatelessWidget {
  final String date;
  final String type;
  final IconData icon; // Ícone ao lado do tipo
  final IconData timeIcon; // Ícone ao lado da data

  const HistoryCard({
    required this.date,
    required this.type,
    required this.icon,
    required this.timeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.brown.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha com o ícone do relógio e a data
          Row(
            children: [
              Icon(timeIcon, color: Colors.green, size: 44), // Ícone do relógio
              SizedBox(width: 20),
              Text(
                date,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 40), // Espaçamento entre as linhas
          // Linha com o ícone do tipo e o texto
          Row(
            children: [
              Icon(icon, color: Colors.green, size: 44), // Ícone ao lado do tipo
              SizedBox(width: 20),
              Text(
                type,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
