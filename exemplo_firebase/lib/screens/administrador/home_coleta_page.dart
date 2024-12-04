import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/controllers/app_bar_adm.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/administrador/reciclados_proximos.dart';
import 'package:flutter/material.dart';
import 'detalhes_reciclado_page.dart';
import 'endereco_page.dart';
import 'profile_adm_page.dart';

class HomeColetaPage extends StatefulWidget {
  const HomeColetaPage({super.key});

  @override
  _HomeColetaPageState createState() => _HomeColetaPageState();
}

class _HomeColetaPageState extends State<HomeColetaPage> {
  bool showMapCard = false;
  int _selectedIndex = 2;
  final user = UserSession();

  List<Map<String, dynamic>> reciclados = [];
  bool isLoading = true;

  final List<Widget> _pages = [
    const NearbyItemsPage(),
    // AreaColetaPage(),
    const EnderecosPage(),
    HomeColetaPage(),
    const ProfileScreenADM(),
  ];

  @override
  void initState() {
    super.initState();
    _loadReciclados();
  }

  Future<void> _loadReciclados() async {
    try {
      List<Map<String, dynamic>> data = await fetchAllReciclado();
      setState(() {
        reciclados = data;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar reciclados: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllReciclado() async {
    List<Map<String, dynamic>> allReciclado = [];

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        String? nome = userData['nome'];
        String? cpf = userData['cpf'];
        String userId = userDoc.id;

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
            'nome': nome,
            'cpf': cpf,
            'endereco': endereco,
            'userId': userId,
            'recicladoId': recicladoDoc.id,
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar reciclados: $e");
    }

    return allReciclado;
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBarADM(user: user),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? _buildLoadingView()
              : reciclados.isEmpty
                  ? _buildEmptyView()
                  : _buildRecicladosList(),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF795548)),
            ),
            SizedBox(height: 16),
            Text(
              'Carregando reciclados...',
              style: TextStyle(
                  color: Color(0xFF795548), fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.recycling,
            size: 100,
            color: Color(0xFF4CAF50),
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum reciclado encontrado.',
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

  Widget _buildRecicladosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: reciclados.length,
      itemBuilder: (context, index) {
        final reciclado = reciclados[index];
        return _buildRecicladoCard(reciclado);
      },
    );
  }

  Widget _buildRecicladoCard(Map<String, dynamic> reciclado) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesRecicladoPage(reciclado: reciclado),
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
              _buildCardHeader(reciclado),
              const SizedBox(height: 12),
              _buildCardDetails(reciclado),
            ],
          ),
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
        _buildDetailRow(
          icon: Icons.location_on,
          label: 'Endereço',
          value: reciclado['endereco'] != null
              ? '${reciclado['endereco']['bairro'] ?? 'Não informado'}'
              : 'Endereço não disponível',
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
}
