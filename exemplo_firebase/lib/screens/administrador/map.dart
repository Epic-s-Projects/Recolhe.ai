import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final String googleApiKey = "AIzaSyCptI-V7_XzK4wNMlHAwPRcwQK-chI-rRQ"; // Insira sua chave da API aqui.
  final List<Map<String, TextEditingController>> points = [];
  List<LatLng> routePoints = []; // Coordenadas para a rota
  List<LatLng> userPoints = []; // Coordenadas dos pontos inseridos pelo usuário

  @override
  void initState() {
    super.initState();
    _addNewPoint(); // Adiciona o primeiro ponto automaticamente
  }

  // Adiciona um novo ponto com campos de entrada
  void _addNewPoint() {
    points.add({
      "cep": TextEditingController(),
      "numero": TextEditingController(),
    });
    setState(() {});
  }

  // Obtém as coordenadas de todos os pontos e traça uma rota real
  Future<void> _fetchCoordinatesAndDrawRoute() async {
    if (points.isEmpty) return;

    try {
      List<String> locations = [];
      List<LatLng> userCoordinates = [];

      for (var point in points) {
        final cep = point['cep']!.text;
        final numero = point['numero']!.text;

        if (cep.isEmpty || numero.isEmpty) return;

        // Combina CEP e número para buscar o endereço completo
        final query = "$cep $numero, Brasil";
        final url = Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$googleApiKey');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['results'].isNotEmpty) {
            final location = data['results'][0]['geometry']['location'];
            final latLng = LatLng(location['lat'], location['lng']);
            userCoordinates.add(latLng);
            locations.add(query);
          }
        }
      }

      if (locations.length < 2) {
        setState(() {
          userPoints = userCoordinates;
          routePoints = [];
        });
        return;
      }

      // Obter a rota entre os pontos usando a API Directions
      final waypoints = locations.skip(1).take(locations.length - 2).join('|');
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${locations.first}&destination=${locations.last}&waypoints=$waypoints&key=$googleApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polyline = _decodePolyline(points);

          // Atualiza os pontos do mapa com os marcadores e a rota
          setState(() {
            userPoints = userCoordinates;
            routePoints = polyline;
          });
        }
      }
    } catch (e) {
      // Caso ocorra algum erro, ele será tratado silenciosamente
    }
  }

  // Decodifica uma polyline em uma lista de LatLng
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rotas com Pontos"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: points.length,
              itemBuilder: (context, index) {
                final point = points[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: point['cep'],
                          decoration: InputDecoration(
                            labelText: "CEP ${index + 1}",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: point['numero'],
                          decoration: InputDecoration(
                            labelText: "Número ${index + 1}",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _addNewPoint,
                child: Text("Adicionar Ponto"),
              ),
              ElevatedButton(
                onPressed: _fetchCoordinatesAndDrawRoute,
                child: Text("Traçar Rota"),
              ),
            ],
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: userPoints.isNotEmpty
                    ? userPoints.first
                    : LatLng(-14.2350, -51.9253), // Centro aproximado do Brasil
                zoom: userPoints.isNotEmpty ? 15.0 : 5.0, // Zoom inicial no Brasil
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: userPoints
                      .map((point) => Marker(
                    point: point,
                    builder: (context) => Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 30,
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}