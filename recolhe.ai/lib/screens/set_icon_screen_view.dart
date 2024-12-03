import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/user_data.dart';
import 'intern_screen_view.dart';

// ignore: must_be_immutable
class SetIconScreen extends StatefulWidget {
  String userId;

  SetIconScreen({super.key, required this.userId});

  @override
  State<SetIconScreen> createState() => _SetIconScreenState();
}

class _SetIconScreenState extends State<SetIconScreen> {
  List<String> imageUrls = [
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://cdn-icons-png.flaticon.com/512/4715/4715329.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
    'https://e7.pngegg.com/pngimages/236/290/png-clipart-super-mario-illustration-mario-party-star-rush-super-mario-bros-princess-peach-luigi-mario-bros-super-mario-bros-nintendo-thumbnail.png',
  ];
  int? selectedIndex; // Índice da imagem selecionada
  final user = UserSession();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF6E9D8), // Bege claro para o topo
              Color(0xFFD5E8D4), // Verde suave para a base
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título no topo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Escolha seu Ícone',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Subtítulo
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Selecione um ícone para personalizar o seu perfil!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Grade de ícones
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex =
                              index; // Atualiza o índice selecionado
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Colors.green
                                  .shade100 // Destaque para o item selecionado
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.green.shade700
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            imageUrls[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Botão de confirmação
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: ElevatedButton(
                  onPressed: selectedIndex != null
                      ? () async {
                          // Atualiza o campo 'imagem' no Firestore
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.userId)
                              .set(
                            {'imagem': imageUrls[selectedIndex!]},
                            SetOptions(merge: true),
                          );

                          // Atualiza a imagem no UserSession
                          user.imagem = imageUrls[selectedIndex!];

                          // Redireciona para a HomePage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      : null,
                  // Desabilita o botão se nenhuma imagem estiver selecionada
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(216.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 21.0, horizontal: 24.0),
                  ),
                  child: const Text(
                    'Confirmar Seleção',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
