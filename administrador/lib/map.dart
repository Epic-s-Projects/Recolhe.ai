import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Realizar Coleta')),
      body: Center(child: Text('Página de Coleta')),
    );
  }
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final String googleApiKey = "AIzaSyCptI-V7_XzK4wNMlHAwPRcwQK-chI-rRQ";
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

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
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

    _geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _checkNearestLocation(position);
      setState(() {
        _currentPosition = position;
        _updateLocations();
        _fetchRoutePoints();
      });
    });
  }

  void _checkNearestLocation(Position currentPosition) {
    _isNearLocation = false;
    _nearestLocation = null;

    for (var location in locations.skip(1)) {
      double distance = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          location['point'].latitude,
          location['point'].longitude
      );

      if (distance <= 4000) {
        _isNearLocation = true;
        _nearestLocation = location;
        break;
      }
    }
  }

  void _updateLocations() {
    if (_currentPosition != null) {
      locations = [
        {
          "point": LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          "address": "Localização Atual",
          "neighborhood": "Atual",
          "city": "Minha Localização",
          "cep": "N/A"
        },
        {
          "point": LatLng(-22.573794911859185, -47.378817687812614),
          "address": "Avenida Secundária, 250",
          "neighborhood": "Jardim Público",
          "city": "Campinas",
          "cep": "13015-002"
        },
        {
          "point": LatLng(-22.678611640730214, -47.291028667977194),
          "address": "Estrada Rural, 500",
          "neighborhood": "Zona Rural",
          "city": "Campinas",
          "cep": "13020-003"
        },
        {
          "point": LatLng(-22.55075624382153, -47.37921564413563),
          "address": "Avenida Major José Levy Sobrinho, 2308",
          "neighborhood": "Zona Rural",
          "city": "Limeira - SP",
          "cep": "13486-190"
        }
      ];
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
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CollectionPage()
                )
            );
          },
          child: Text(
            'Fazer Coleta em ${_nearestLocation?['address']}',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _isFullScreenMap
              ? _buildFullScreenMap()
              : _buildNormalView(),
          _buildCollectionButton()
        ],
      ),
    );
  }

// Resto do código anterior permanece o mesmo (métodos _buildFullScreenMap, _buildNormalView, etc.)


  Widget _buildFullScreenMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: locations[_currentPageIndex]['point'],
            zoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: locations.map((loc) =>
                  Marker(
                    point: loc['point'],
                    builder: (context) {
                      if (locations.indexOf(loc) == 0) {
                        return Icon(
                          Icons.person_pin_circle,
                          color: Colors.purple,
                          size: 50,
                        );
                      }
                      return Icon(
                        Icons.location_pin,
                        color: locations.indexOf(loc) == _currentPageIndex
                            ? Colors.red
                            : Colors.blue,
                        size: 40,
                      );
                    },
                  )
              ).toList(),
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
            icon: Icon(Icons.close_fullscreen, color: Colors.black, size: 30),
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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            child: Stack(
              children: [
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
                Positioned(
                  top: 10,
                  right: 20,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/user_avatar.png'),
                    radius: 30,
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
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: locations.map((loc) =>
                          Marker(
                            point: loc['point'],
                            builder: (context) {
                              if (locations.indexOf(loc) == 0) {
                                return Icon(
                                  Icons.person_pin_circle,
                                  color: Colors.purple,
                                  size: 50,
                                );
                              }
                              return Icon(
                                Icons.location_pin,
                                color: locations.indexOf(loc) == _currentPageIndex
                                    ? Colors.red
                                    : Colors.blue,
                                size: 40,
                              );
                            },
                          )
                      ).toList(),
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Distância: ${totalDistance.toStringAsFixed(2)} km",
                      style: TextStyle(
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
                    icon: Icon(Icons.fullscreen, color: Colors.black, size: 30),
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
          Container(
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
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: index == _currentPageIndex ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
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
                          index == 0 ? "Localização Atual" : "Localização ${index + 1}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: index == _currentPageIndex ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Endereço: ${location['address']}",
                          style: TextStyle(
                            color: index == _currentPageIndex ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          "Bairro: ${location['neighborhood']}",
                          style: TextStyle(
                            color: index == _currentPageIndex ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          "Cidade: ${location['city']}",
                          style: TextStyle(
                            color: index == _currentPageIndex ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          "CEP: ${location['cep']}",
                          style: TextStyle(
                            color: index == _currentPageIndex ? Colors.white : Colors.black,
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
      final locationStrings = locations.map((loc) =>
      "${loc['point'].latitude},${loc['point'].longitude}").toList();

      final waypoints = locationStrings.skip(1).take(locationStrings.length - 2).join('|');
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${locationStrings.first}&destination=${locationStrings.last}&waypoints=$waypoints&key=$googleApiKey'
      );

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
