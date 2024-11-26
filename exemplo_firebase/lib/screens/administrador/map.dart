import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

// flutter_map: ^4.0.0
// latlong2: ^0.8.1
// http: ^0.13.6

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _isCardExpanded = true;

  // LatLng para a posição inicial e final do mapa
  final LatLng start = LatLng(-22.57081484823618, -47.40388080106317); // Exemplo: São Paulo
  final LatLng end = LatLng(-22.678611640730214, -47.291028667977194); // Outro ponto em São Paulo
  double _totalDistance = 0.0; // Distância total da rota

  @override
  void initState() {
    super.initState();
    _calculateTotalDistance(); // Calcula a distância total ao iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'), // Imagem do fundo
            fit: BoxFit.cover, // Preenche toda a tela
          ),
        ),
        child: Column(
          children: [
            // Avatar, saudação e botão de voltar
            Container(
              height: 100,
              child: Stack(
                children: [
                  // Ícone de voltar
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.green, size: 40),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  // Avatar do usuário
                  Positioned(
                    top: 10,
                    right: 20,
                    child: CircleAvatar(

                      radius: 30,
                    ),
                  ),
                  // Saudação
                  Positioned(
                    top: 30,
                    right: 80,
                    child: Text(
                      "Olá, João!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Área do mapa
            Expanded(
              child: Stack(
                children: [
                  // Mapa
                  FutureBuilder<List<LatLng>>(
                    future: _getRoutePoints(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Erro ao carregar rota'));
                      }

                      final routePoints = snapshot.data ?? [];

                      return FlutterMap(
                        options: MapOptions(
                          center: start,
                          zoom: 13.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: start,
                                builder: (context) => Icon(
                                  Icons.location_pin,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ),
                              Marker(
                                point: end,
                                builder: (context) => Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: routePoints,
                                strokeWidth: 4.0,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  // Botão de expandir/reduzir o card
                  Positioned(
                    top: 20,
                    right: 20,
                    child: IconButton(
                      icon: Icon(
                        _isCardExpanded
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCardExpanded = !_isCardExpanded;
                        });
                      },
                    ),
                  ),

                  // Distância no canto superior esquerdo do mapa
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Distância: ${_totalDistance.toStringAsFixed(2)} km",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card de informações
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isCardExpanded ? 200 : 50,
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título do card
                  Text(
                    "INFORMAÇÕES",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_isCardExpanded)
                    SizedBox(height: 10), // Espaçamento
                  if (_isCardExpanded)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Endereço: 2 Penn Plz Fl",
                            style: TextStyle(color: Colors.white)),
                        Text("Número: 15",
                            style: TextStyle(color: Colors.white)),
                        Text("Complemento: ",
                            style: TextStyle(color: Colors.white)),
                        Text("CEP: 10121-1703",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
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

          },
        ),
      ),
    );
  }

  // Função para calcular a distância total da rota
  Future<void> _calculateTotalDistance() async {
    final routePoints = await _getRoutePoints();
    double distance = 0.0;

    for (int i = 0; i < routePoints.length - 1; i++) {
      distance += Distance().as(
        LengthUnit.Kilometer,
        routePoints[i],
        routePoints[i + 1],
      );
    }

    setState(() {
      _totalDistance = distance;
    });
  }

  // Função para obter os pontos da rota
  Future<List<LatLng>> _getRoutePoints() async {
    final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?steps=true&geometries=geojson');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final geometry = data['routes'][0]['geometry'];
      final coordinates = geometry['coordinates'];

      return coordinates.map<LatLng>((coord) {
        return LatLng(coord[1], coord[0]);
      }).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }
}