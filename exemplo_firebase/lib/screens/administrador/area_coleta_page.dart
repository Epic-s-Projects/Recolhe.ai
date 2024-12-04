import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/administrador/map.dart';
import 'package:flutter/material.dart';

class AreaColetaPage extends StatefulWidget {
  @override
  _AreaColetaPageState createState() => _AreaColetaPageState();
}

class _AreaColetaPageState extends State<AreaColetaPage> {
  bool showMapCard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(user: UserSession()),
      body: Stack(
        children: [
          // Soft gradient background instead of plain image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    BlendMode.lighten,
                  ),
                ),
              ),
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                    // Colors.green.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),

          // Centered content with soft animations
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            // child: !showMapCard ? _buildInitialContent() : _buildMapCard(),
            child: _buildInitialContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Aguardando entrada\nem área de coleta!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade900,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            // onPressed: () => setState(() => showMapCard = true),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
            icon: const Icon(Icons.location_pin, color: Colors.white),
            label:
                const Text('Ver Mapa', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildMapCard() {
  //   return Center(
  //     child: Container(
  //       width: 320,
  //       padding: const EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
  //             blurRadius: 15,
  //             offset: const Offset(0, 8),
  //           )
  //         ],
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Lixo de João!',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.green.shade700,
  //                 ),
  //               ),
  //               IconButton(
  //                 icon: const Icon(Icons.close, color: Colors.grey),
  //                 onPressed: () => setState(() => showMapCard = false),
  //               ),
  //             ],
  //           ),
  //           Divider(color: Colors.green.shade100),
  //           const SizedBox(height: 10),
  //           _buildInfoRow(Icons.electrical_services, 'Eletrônico'),
  //           const SizedBox(height: 10),
  //           _buildInfoRow(Icons.oil_barrel, 'Óleo'),
  //           const SizedBox(height: 20),
  //           Center(
  //             child: ElevatedButton(
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => MapPage()),
  //                 );
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.green.shade50,
  //                 foregroundColor: Colors.green.shade800,
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //               ),
  //               child: const Text(
  //                 'VER LOCAL',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   letterSpacing: 1.2,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade600),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.green.shade800,
          ),
        ),
      ],
    );
  }
}
