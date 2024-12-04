import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/app_bar_adm.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/administrador/profile_adm_page.dart';
import 'package:exemplo_firebase/screens/administrador/reciclado_por_endereco_page.dart';
import 'package:exemplo_firebase/screens/administrador/reciclados_proximos.dart';
import 'package:flutter/material.dart';

import 'home_coleta_page.dart';

class EnderecosPage extends StatefulWidget {
  const EnderecosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EnderecosPageState createState() => _EnderecosPageState();
}

class _EnderecosPageState extends State<EnderecosPage> {
  List<Map<String, dynamic>> enderecos = [];
  bool isLoading = true;
  int _selectedIndex = 1;
  final user = UserSession();

  final List<Widget> _pages = [
    const NearbyItemsPage(),
    // AreaColetaPage(),
    const EnderecosPage(),
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
    _loadEnderecos();
  }

  Future<void> _loadEnderecos() async {
    try {
      List<Map<String, dynamic>> data = await fetchAllEnderecos();
      setState(() {
        enderecos = data;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar endereços: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllEnderecos() async {
    List<Map<String, dynamic>> allEnderecos = [];

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        QuerySnapshot enderecoSnapshot =
            await userDoc.reference.collection("endereco").get();

        for (QueryDocumentSnapshot enderecoDoc in enderecoSnapshot.docs) {
          allEnderecos.add({
            ...enderecoDoc.data() as Map<String, dynamic>,
            'userId': userDoc.id,
            'enderecoId': enderecoDoc.id,
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar endereços: $e");
    }

    return allEnderecos;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBarADM(user: user),
        body: SafeArea(
          child: isLoading
              ? _buildLoadingView()
              : enderecos.isEmpty
                  ? _buildEmptyView()
                  : _buildEnderecosList(),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 46, 50, 46),
                Color.fromARGB(255, 28, 30, 28),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BottomNavigationBar(
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
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF795548)),
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 100,
            color: Color(0xFF4CAF50),
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum endereço encontrado.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF795548),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnderecosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: enderecos.length,
      itemBuilder: (context, index) {
        final endereco = enderecos[index];
        return _buildEnderecoCard(endereco);
      },
    );
  }

  Widget _buildEnderecoCard(Map<String, dynamic> endereco) {
    final numero = endereco['numero'] ?? 'Número não disponível';
    final rua = endereco['rua'] ?? 'Rua não disponível';
    final cep = endereco['cep'] ?? 'CEP não informado';
    final bairro = endereco['bairro'] ?? 'Bairro não informado';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecicladosPorEnderecoPage(
              endereco: endereco,
            ),
          ),
        );
      },
      child: Card(
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
              Text(
                bairro,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${rua ?? "Rua não disponível"}, ${numero ?? "Número não disponível"}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                cep,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
