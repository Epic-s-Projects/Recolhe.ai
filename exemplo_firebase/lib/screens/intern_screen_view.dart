import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controllers/user_data.dart';
import 'profile_screen_view.dart';
import 'selection_screen_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showCards = false; // Controle para exibir imagem ou cards
  final user = UserSession();

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Carrega os dados do usuário no início
  }

  Future<void> fetchUserData() async {
    // Busca os dados do Firestore
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user
              .userId) // Certifica-se de que está pegando o ID do usuário autenticado
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        user.email = data['email'] ?? 'email@exemplo.com';
        user.name = data['nome'] ?? 'Usuário';
        user.cpf = data['cpf'] ?? '123';
        user.imagem = data['imagem'] ?? '';

        // Printando os dados para verificar
        print("Nome: ${user.name}");
        print("Email: ${user.email}");
        print("CPF: ${user.cpf}");
        print("Imagem: ${user.imagem}");
        print("UserID: ${user.userId}");

        // Agora verifica se há itens "Em processo" na coleção "reciclado"
        final recicladoCollection = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.userId)
            .collection('reciclado')
            .where('status', isEqualTo: 'Em processo')
            .get();

        setState(() {
          // Se houver documentos na subcoleção "reciclado" com status "Em processo", define showCards como true
          showCards = recicladoCollection.docs.isNotEmpty;
        });

        // Printar o valor de showCards para verificar
        print("Show Cards: $showCards");
      } else {
        print("Documento do usuário não encontrado no Firestore.");
      }
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 209, 186),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 209, 186),
        elevation: 0,
        title: Text(
          'Olá, ${user.name}!',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 56, 128, 59),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: (user.imagem != null && user.imagem!.isNotEmpty)
                  ? ClipOval(
                      child: Image.network(
                        user.imagem!,
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFF7B2CBF),
                    ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildWeekDays(),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: showCards
                    ? _buildCards() // Exibe os cards se houver itens "Em processo"
                    : _buildImageAndText(), // Exibe a imagem e o texto principal
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCards() {
    if (user.userId == null) {
      // Certifica-se que o UserID está disponível
      return const CircularProgressIndicator();
    }

    // Adiciona um filtro para trazer apenas os documentos com o status "Em processo"
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .collection('reciclado')
          .where(
          'status', isEqualTo: 'Em processo') // Filtra por status "Em processo"
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildImageAndText();
        }

        final docs = snapshot.data!.docs;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return Card(
                    shadowColor: const Color.fromARGB(255, 0, 0, 0),
                    color: const Color.fromRGBO(218, 194, 162, 1),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/folhas2.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tipo: ${data['tipo'] ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Quantidade: ${data['qtd'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Status: ${data['status'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Data: ${data['timestamp'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectionScreenView(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(149, 5, 23, 5),
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: const Text(
                'Realize sua coleta',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }



    Widget _buildImageAndText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/banner_inicial.png',
          height: 400,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 20),
        const Text(
          'Você ainda não realizou nenhuma coleta!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectionScreenView(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(149, 5, 23, 5),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 20),
          label: const Text(
            'Realize sua coleta',
            style: TextStyle(fontSize: 20, color: Colors.white),
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
      onTap: (index) {
        switch (index) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 50),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 50),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment, size: 50),
          label: 'Tarefas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag, size: 50),
          label: 'Loja',
        ),
      ],
    );
  }
}

Widget _buildWeekDays() {
  final List<Map<String, dynamic>> days = [
    {"day": "S", "color": Colors.blue},
    {"day": "T", "color": Colors.grey},
    {"day": "Q", "color": Colors.grey},
    {"day": "Q", "color": Colors.orange},
    {"day": "S", "color": Colors.grey},
    {"day": "S", "color": Colors.grey},
    {"day": "D", "color": Colors.grey},
  ];

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(16, 148, 16, 1),
      borderRadius: BorderRadius.circular(90),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map((day) => CircleAvatar(
                radius: 20,
                backgroundColor: day['color'],
                child: Text(
                  day['day'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
    ),
  );
}
