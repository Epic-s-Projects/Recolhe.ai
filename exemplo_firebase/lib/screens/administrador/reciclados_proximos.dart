import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NearbyRecicladosPage extends StatefulWidget {
  @override
  _NearbyRecicladosPageState createState() => _NearbyRecicladosPageState();
}

class _NearbyRecicladosPageState extends State<NearbyRecicladosPage> {
  List<Map<String, dynamic>> recicladosProximos = [];
  bool isLoading = true;
  Position? userPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocationAndFilterReciclados();
  }

  Future<void> _getUserLocationAndFilterReciclados() async {
    try {
      // Obtenha a localização atual do usuário
      userPosition = await _determinePosition();

      // Busque os reciclados
      List<Map<String, dynamic>> allReciclados = await fetchAllReciclado();

      // Filtre apenas os reciclados próximos (200 metros ou menos)
      recicladosProximos = allReciclados.where((reciclado) {
        final endereco = reciclado['endereco'];
        if (endereco != null &&
            endereco['latitude'] != null &&
            endereco['longitude'] != null) {
          final double distance = Geolocator.distanceBetween(
            userPosition!.latitude,
            userPosition!.longitude,
            endereco['latitude'],
            endereco['longitude'],
          );
          return distance <= 200; // Filtra os que estão a 200 metros ou menos
        }
        return false;
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao obter reciclados próximos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifique se o serviço de localização está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desabilitado.');
    }

    // Verifique as permissões de localização
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Permissão de localização permanentemente negada, não podemos acessar a localização.');
    }

    // Obtenha a posição atual
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Map<String, dynamic>>> fetchAllReciclado() async {
    List<Map<String, dynamic>> allReciclado = [];
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        QuerySnapshot recicladoSnapshot = await userDoc.reference
            .collection("reciclado")
            .where("status", isEqualTo: "Em processo")
            .get();

        QuerySnapshot enderecoSnapshot =
            await userDoc.reference.collection("endereco").get();

        Map<String, dynamic>? endereco;
        if (enderecoSnapshot.docs.isNotEmpty) {
          endereco = enderecoSnapshot.docs.first.data() as Map<String, dynamic>;
        }

        for (QueryDocumentSnapshot recicladoDoc in recicladoSnapshot.docs) {
          allReciclado.add({
            ...recicladoDoc.data() as Map<String, dynamic>,
            'endereco': endereco,
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar reciclados: $e");
    }

    return allReciclado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reciclados Próximos"),
        backgroundColor: Color(0xFF4CAF50),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : recicladosProximos.isEmpty
              ? Center(
                  child: Text(
                    "Nenhum reciclado encontrado próximo de você.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: recicladosProximos.length,
                  itemBuilder: (context, index) {
                    final reciclado = recicladosProximos[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reciclado['tipo'] ?? 'Tipo não disponível',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32)),
                            ),
                            SizedBox(height: 8),
                            Text(
                              reciclado['endereco'] != null
                                  ? reciclado['endereco']['bairro'] ??
                                      'Endereço não disponível'
                                  : 'Endereço não disponível',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
