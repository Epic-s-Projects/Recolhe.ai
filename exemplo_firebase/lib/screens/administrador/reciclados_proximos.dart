import 'dart:convert';
import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/controllers/app_bar_adm.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/administrador/profile_adm_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'area_coleta_page.dart';
import 'chatbot_page.dart';
import 'detalhes_reciclado_page.dart';
import 'endereco_page.dart';
import 'home_coleta_page.dart';

class NearbyItemsPage extends StatefulWidget {
  const NearbyItemsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NearbyItemsPageState createState() => _NearbyItemsPageState();
}

class _NearbyItemsPageState extends State<NearbyItemsPage> {
  List<Map<String, dynamic>> nearbyItems = [];
  bool isLoading = true;
  Position? userPosition;
  final user = UserSession();
  int _selectedIndex = 0;
  final String googleApiKey = "AIzaSyCptI-V7_XzK4wNMlHAwPRcwQK-chI-rRQ";

  final List<Widget> _pages = [
    const NearbyItemsPage(),
    // AreaColetaPage(),
    EnderecosPage(),
    HomeColetaPage(),
    const ProfileScreenADM(),
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
  void initState() {
    super.initState();
    _fetchNearbyItems();
  }

  Future<void> _fetchNearbyItems() async {
    try {
      userPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      if (userPosition == null) {
        throw Exception('Localização do usuário não encontrada.');
      }

      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      List<Map<String, dynamic>> allNearbyItems = [];

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        String nome = userData['nome'] ?? 'Usuário Não Disponível';
        String cpf = userData['cpf'] ?? 'CPF Não Disponível';

        QuerySnapshot recicladoSnapshot = await userDoc.reference
            .collection("reciclado")
            .where("status", isEqualTo: "Em processo")
            .get();

        QuerySnapshot enderecoSnapshot =
            await userDoc.reference.collection("endereco").get();

        for (QueryDocumentSnapshot recicladoDoc in recicladoSnapshot.docs) {
          final recicladoData = recicladoDoc.data() as Map<String, dynamic>;

          if (enderecoSnapshot.docs.isNotEmpty) {
            final enderecoData =
                enderecoSnapshot.docs.first.data() as Map<String, dynamic>;

            final coordinates = await _getCoordinatesFromAddress(
              rua: enderecoData['rua'],
              numero: enderecoData['numero'],
              bairro: enderecoData['bairro'],
              cep: enderecoData['cep'],
            );

            if (coordinates != null) {
              double distance = Geolocator.distanceBetween(
                userPosition!.latitude,
                userPosition!.longitude,
                coordinates['lat']!,
                coordinates['lng']!,
              );

              if (distance <= 500) {
                allNearbyItems.add({
                  ...recicladoData,
                  'distance': distance,
                  'endereco': enderecoData,
                  'nome': nome,
                  'cpf': cpf,
                });
              }
            }
          }
        }
      }

      setState(() {
        nearbyItems = allNearbyItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, double>?> _getCoordinatesFromAddress({
    required String rua,
    required String numero,
    required String bairro,
    required String cep,
  }) async {
    try {
      final address = "$rua $numero, $bairro, $cep, Brasil";
      final url = Uri.parse(
          "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleApiKey");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return {'lat': location['lat'], 'lng': location['lng']};
        }
      }
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarADM(user: user), // Removido o parêntese extra
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    children: [
                      // Botão "Iniciar Coleta"
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AreaColetaPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Iniciar Coleta',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botão "Ver Itens"
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeColetaPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Ver Itens',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Lista de itens próximos
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF795548)),
                        ),
                      )
                    : nearbyItems.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 100,
                                  color: Colors.white70,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhum item próximo encontrado.',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: nearbyItems.length,
                            itemBuilder: (context, index) {
                              final item = nearbyItems[index];
                              return _buildNearbyCard(item);
                            },
                          ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ChatDialog(),
          );
        },
        child: Icon(Icons.smart_toy, color: Colors.white),
        backgroundColor: Colors.brown,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  Widget _buildNearbyCard(Map<String, dynamic> reciclado) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(reciclado),
            const SizedBox(height: 12),
            _buildCardDetails(reciclado),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(Map<String, dynamic> reciclado) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            reciclado['tipo'] ?? 'Tipo não disponível',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            reciclado['status'] ?? 'Não informado',
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardDetails(Map<String, dynamic> reciclado) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          icon: Icons.view_in_ar,
          label: 'Quantidade',
          value: reciclado['qtd']?.toString() ?? 'Não disponível',
        ),
        const SizedBox(height: 8),
        _buildDetailRow(
          icon: Icons.person,
          label: 'Usuário',
          value: reciclado['nome'] ?? 'Nome não disponível',
        ),
        const SizedBox(height: 8),
        _buildDetailRow(
          icon: Icons.location_on,
          label: 'Endereço',
          value: reciclado['endereco'] != null
              ? '${reciclado['endereco']['bairro'] ?? 'Não informado'}, ${reciclado['endereco']['rua'] ?? ''} ${reciclado['endereco']['numero'] ?? ''}'
              : 'Endereço não disponível',
        ),
        const SizedBox(height: 8),
        _buildDetailRow(
          icon: Icons.location_searching,
          label: 'Distância',
          value: '${reciclado['distance']?.toStringAsFixed(2) ?? '--'} metros',
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF795548),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
