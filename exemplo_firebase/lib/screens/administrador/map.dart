import 'dart:convert';
import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final String googleApiKey =
      "AIzaSyCptI-V7_XzK4wNMlHAwPRcwQK-chI-rRQ"; // Insira sua chave da API aqui.
  List<LatLng> routePoints = []; // Coordenadas para a rota
  List<LatLng> userPoints = []; // Coordenadas dos endereços do Firebase
  final user = UserSession();

  @override
  void initState() {
    super.initState();
    _fetchCoordinatesAndDrawRoute(); // Busca os dados ao iniciar
  }

  // Busca todos os endereços cadastrados no Firebase Firestore
  Future<List<Map<String, dynamic>>> fetchAllAddresses() async {
    List<Map<String, dynamic>> allAddresses = [];

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        QuerySnapshot enderecoSnapshot =
            await userDoc.reference.collection("endereco").get();

        for (QueryDocumentSnapshot enderecoDoc in enderecoSnapshot.docs) {
          allAddresses.add({
            ...enderecoDoc.data() as Map<String, dynamic>,
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar endereços: $e");
    }

    return allAddresses;
  }

  // Obtém as coordenadas dos endereços do Firestore e traça a rota
  Future<void> _fetchCoordinatesAndDrawRoute() async {
    try {
      // Passo 1: Obter endereços do Firestore
      List<Map<String, dynamic>> addresses = await fetchAllAddresses();

      List<String> locations = [];
      List<LatLng> coordinates = [];

      // Passo 2: Converter endereços em coordenadas
      for (var address in addresses) {
        final rua = address['rua'] ?? '';
        final bairro = address['bairro'] ?? '';
        final numero = address['numero'] ?? '';
        final cep = address['cep'] ?? '';

        final query = "$rua $numero, $bairro, $cep, Brasil";
        final url = Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=$googleApiKey');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['results'].isNotEmpty) {
            final location = data['results'][0]['geometry']['location'];
            final latLng = LatLng(location['lat'], location['lng']);
            coordinates.add(latLng);
            locations.add(query);
          }
        }
      }

      if (locations.length < 2) {
        setState(() {
          userPoints = coordinates;
          routePoints = [];
        });
        return;
      }

      // Passo 3: Obter a rota entre os pontos
      final waypoints = locations.skip(1).take(locations.length - 2).join('|');
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${locations.first}&destination=${locations.last}&waypoints=$waypoints&key=$googleApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polyline = _decodePolyline(points);

          setState(() {
            userPoints = coordinates;
            routePoints = polyline;
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar coordenadas e traçar rota: $e");
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
      appBar: CustomAppBar(user: user),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: userPoints.isNotEmpty
                    ? userPoints.first
                    : LatLng(-14.2350, -51.9253), // Centro aproximado do Brasil
                zoom: userPoints.isNotEmpty
                    ? 15.0
                    : 5.0, // Zoom inicial no Brasil
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
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
                            builder: (context) => const Icon(
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
          ElevatedButton(
            onPressed: _fetchCoordinatesAndDrawRoute,
            child: const Text("Atualizar Rotas"),
          ),
        ],
      ),
    );
  }
}
