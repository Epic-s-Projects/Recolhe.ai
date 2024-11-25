import 'package:exemplo_firebase/controllers/historic_controller.dart';
import 'package:flutter/material.dart';

class HistoricScreenView extends StatelessWidget {
  final HistoricController controller = HistoricController();

  HistoricScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Caminho da imagem
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Ícone de voltar
          Positioned(
            top: size.height * 0.05,
            left: size.width * 0.05,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Colors.green, size: size.width * 0.1),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Avatar do usuário
          Positioned(
            top: size.height * 0.04,
            right: size.width * 0.05,
            child: CircleAvatar(
              backgroundImage: const AssetImage('assets/user_avatar.png'),
              radius: size.width * 0.08,
            ),
          ),
          // Conteúdo principal
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título da seção
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.06),
                  child: Center(
                    child: Text(
                      "Históricos",
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ),
                // Área de rolagem do histórico
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: Column(
                        children: List.generate(
                          12,
                          (index) => Padding(
                            padding:
                                EdgeInsets.only(bottom: size.height * 0.02),
                            child: const HistoryCard(
                              date: "02/12/2024 - 18:47",
                              type: "Eletrônico e Óleo",
                              timeIcon: Icons.access_time,
                              icon: Icons.recycling,
                            ),
                          ),
                        ),
                      ),
                    ),
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
          iconSize: size.width * 0.08,
          items: const [
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
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
      decoration: BoxDecoration(
        color: Colors.brown.shade700,
        borderRadius: BorderRadius.circular(size.width * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha com o ícone do relógio e a data
          Row(
            children: [
              Icon(timeIcon, color: Colors.green, size: size.width * 0.08),
              SizedBox(width: size.width * 0.05),
              Expanded(
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          // Linha com o ícone do tipo e o texto
          Row(
            children: [
              Icon(icon, color: Colors.green, size: size.width * 0.08),
              SizedBox(width: size.width * 0.05),
              Expanded(
                child: Text(
                  type,
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
