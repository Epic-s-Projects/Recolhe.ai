import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:exemplo_firebase/screens/administrador/reciclados_proximos.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final String googleApiKey =
      "AIzaSyCptI-V7_XzK4wNMlHAwPRcwQK-chI-rRQ"; // Replace with your key
  final PageController _pageController = PageController();
  final MapController _mapController = MapController();
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;

  Position? _currentPosition;
  List<Map<String, dynamic>> locations = [];
  int _currentPageIndex = 0;
  List<LatLng> routePoints = [];
  double totalDistance = 0.0;
  bool _isFullScreenMap = false;
  bool _isNearLocation = false;
  Map<String, dynamic>? _nearestLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadLocationsAndRoutes();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    _geolocator
        .getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    )
        .listen((Position position) {
      setState(() {
        _currentPosition = position;
        _updateLocations();
      });
    });
  }

  void _updateLocations() {
    if (_currentPosition != null) {
      // Remove existing current location if exists
      locations.removeWhere((loc) => loc['address'] == "Localização Atual");

      locations.insert(0, {
        "point":
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        "address": "Localização Atual",
        "neighborhood": "Atual",
        "city": "Minha Localização",
        "cep": "N/A",
      });
    }
  }

  Future<void> _loadLocationsAndRoutes() async {
    try {
      // Fetch all reciclado locations
      List<Map<String, dynamic>> recicladoLocations = await fetchAllReciclado();

      // Convert addresses to coordinates
      for (var location in recicladoLocations) {
        if (location['endereco'] != null) {
          String cep = location['endereco']['cep'] ?? '';
          String numero = location['endereco']['numero'] ?? '';

          LatLng? coordinates = await _getCoordinatesFromAddress(cep, numero);

          if (coordinates != null) {
            locations.add({
              "point": coordinates,
              "address":
                  "${location['endereco']['logradouro'] ?? ''}, ${numero}",
              "neighborhood": location['endereco']['bairro'] ?? '',
              "city": location['endereco']['cidade'] ?? '',
              "cep": cep,
            });
          }
        }
      }

      // Fetch route points for all locations if more than one location
      if (locations.length > 1) {
        await _fetchRoutePointsForAllLocations();
      }

      // Check nearest location
      if (_currentPosition != null) {
        _checkNearestLocation(_currentPosition!);
      }

      // Trigger a rebuild to show locations
      setState(() {
        _isLoading = false;
        if (locations.isNotEmpty) {
          _centerMapOnLocation(locations.first['point']);
        }
      });
    } catch (e) {
      print('Error loading locations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRoutePointsForAllLocations() async {
    try {
      // Convert points to location strings
      final locationStrings = locations
          .map((loc) => "${loc['point'].latitude},${loc['point'].longitude}")
          .toList();

      // Construct waypoints (all points except first and last)
      final waypoints =
          locationStrings.skip(1).take(locationStrings.length - 2).join('|');

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${locationStrings.first}&destination=${locationStrings.last}&waypoints=optimize:true|$waypoints&key=$googleApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polyline = _decodePolyline(points);

          // Calculate total distance
          totalDistance = 0.0;
          for (int i = 0; i < polyline.length - 1; i++) {
            totalDistance += _calculateDistance(polyline[i], polyline[i + 1]);
          }

          setState(() {
            routePoints = polyline;
          });
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllReciclado() async {
    List<Map<String, dynamic>> allReciclado = [];

    try {
      // Obtém todos os documentos da coleção "users"
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        // Dados do usuário atual
        final userData = userDoc.data() as Map<String, dynamic>;
        String? nome = userData['nome'];
        String? cpf = userData['cpf'];
        String userId = userDoc.id;

        // Busca documentos na subcoleção "reciclado" com status "Em processo"
        QuerySnapshot recicladoSnapshot = await userDoc.reference
            .collection("reciclado")
            .where("status", isEqualTo: "Em processo")
            .get();

        // Busca documentos na subcoleção "endereco"
        QuerySnapshot enderecoSnapshot =
            await userDoc.reference.collection("endereco").get();

        // Obtém o primeiro endereço, se existir
        Map<String, dynamic>? endereco;
        if (enderecoSnapshot.docs.isNotEmpty) {
          endereco = enderecoSnapshot.docs.first.data() as Map<String, dynamic>;
        }

        // Itera pelos documentos da subcoleção "reciclado"
        for (QueryDocumentSnapshot recicladoDoc in recicladoSnapshot.docs) {
          // Adiciona os dados consolidados à lista
          allReciclado.add({
            ...recicladoDoc.data()
                as Map<String, dynamic>, // Dados do reciclado
            'nome': nome,
            'cpf': cpf,
            'endereco': endereco,
            'userId': userId,
            'recicladoId': recicladoDoc.id,
          });
        }
      }
    } catch (e) {
      // Captura erros e imprime no console
      print('Erro ao buscar dados de reciclados: $e');
    }

    return allReciclado; // Retorna a lista de reciclados
  }

  Future<LatLng?> _getCoordinatesFromAddress(String cep, String numero) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$cep+$numero&key=$googleApiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
    } catch (e) {
      print('Erro ao buscar coordenadas: $e');
    }
    return null;
  }

  void _checkNearestLocation(Position currentPosition) {
    _isNearLocation = false;
    _nearestLocation = null;

    for (var location in locations) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        location['point'].latitude,
        location['point'].longitude,
      );

      if (distance <= 4000) {
        _isNearLocation = true;
        _nearestLocation = location;
        break;
      }
    }
  }

  void _centerMapOnLocation(LatLng location) {
    _mapController.move(location, 13.0);
  }

  Widget _buildCollectionButton() {
    if (_isNearLocation) {
      return Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NearbyItemsPage()),
            );
          },
          child: Text(
            'Fazer Coleta em ${_nearestLocation?['address']}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (locations.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Nenhuma localização encontrada')),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _isFullScreenMap ? _buildFullScreenMap() : _buildNormalView(),
          _buildCollectionButton(),
        ],
      ),
    );
  }

  Widget _buildFullScreenMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: locations[_currentPageIndex]['point'],
            zoom: 10.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: locations
                  .map((loc) => Marker(
                        point: loc['point'],
                        builder: (context) {
                          return Icon(
                            Icons.location_pin,
                            color: locations.indexOf(loc) == _currentPageIndex
                                ? Colors.red
                                : Colors.blue,
                            size: 40,
                          );
                        },
                      ))
                  .toList(),
            ),
            if (routePoints.isNotEmpty)
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
        ),
        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close_fullscreen,
                color: Colors.black, size: 30),
            onPressed: () {
              setState(() {
                _isFullScreenMap = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNormalView() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.highlight_remove_outlined,
                        color: Colors.green, size: 45),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: locations[_currentPageIndex]['point'],
                    zoom: 10.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: locations
                          .map((loc) => Marker(
                                point: loc['point'],
                                builder: (context) {
                                  return Icon(
                                    Icons.location_pin,
                                    color: locations.indexOf(loc) ==
                                            _currentPageIndex
                                        ? Colors.red
                                        : Colors.blue,
                                    size: 40,
                                  );
                                },
                              ))
                          .toList(),
                    ),
                    if (routePoints.isNotEmpty)
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
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Distância: ${totalDistance.toStringAsFixed(2)} km",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen,
                        color: Colors.black, size: 30),
                    onPressed: () {
                      setState(() {
                        _isFullScreenMap = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: locations.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                  _centerMapOnLocation(locations[index]['point']);
                });
              },
              itemBuilder: (context, index) {
                final location = locations[index];
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: index == _currentPageIndex
                        ? Colors.green
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index == 0
                              ? "Localização Atual"
                              : "Localização ${index + 1}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: index == _currentPageIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Endereço: ${location['address']}",
                          style: TextStyle(
                            color: index == _currentPageIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "Bairro: ${location['neighborhood']}",
                          style: TextStyle(
                            color: index == _currentPageIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "Cidade: ${location['city']}",
                          style: TextStyle(
                            color: index == _currentPageIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text(
                          "CEP: ${location['cep']}",
                          style: TextStyle(
                            color: index == _currentPageIndex
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// Existing methods _fetchRoutePoints, _decodePolyline, _calculateDistance remain the same
// Fetch route points using Google Directions API
  Future<void> _fetchRoutePoints() async {
    if (locations.length < 2) return;

    try {
      // Convert points to location strings
      final locationStrings = locations
          .map((loc) => "${loc['point'].latitude},${loc['point'].longitude}")
          .toList();

      final waypoints =
          locationStrings.skip(1).take(locationStrings.length - 2).join('|');
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${locationStrings.first}&destination=${locationStrings.last}&waypoints=$waypoints&key=$googleApiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          final polyline = _decodePolyline(points);

          // Calculate total distance
          totalDistance = 0.0;
          for (int i = 0; i < polyline.length - 1; i++) {
            totalDistance += _calculateDistance(polyline[i], polyline[i + 1]);
          }

          setState(() {
            routePoints = polyline;
          });
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  // Decode polyline to list of coordinates
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

  // Calculate distance between two points using Haversine formula
  double _calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371; // Earth radius in km
    final lat1 = point1.latitude * (pi / 180);
    final lon1 = point1.longitude * (pi / 180);
    final lat2 = point2.latitude * (pi / 180);
    final lon2 = point2.longitude * (pi / 180);

    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;

    final a = (sin(dlat / 2) * sin(dlat / 2)) +
        cos(lat1) * cos(lat2) * (sin(dlon / 2) * sin(dlon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in km
  }
}
