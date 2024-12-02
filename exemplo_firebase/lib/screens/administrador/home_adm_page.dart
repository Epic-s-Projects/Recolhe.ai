// import 'package:exemplo_firebase/controllers/app_bar.dart';
// import 'package:exemplo_firebase/controllers/app_bar_adm.dart';
// import 'package:exemplo_firebase/controllers/user_data.dart';
// import 'package:exemplo_firebase/screens/administrador/endereco_page.dart';
// import 'package:exemplo_firebase/screens/administrador/reciclados_proximos.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'profile_adm_page.dart';
// import 'home_coleta_page.dart'; // Página já criada anteriormente
// import 'area_coleta_page.dart'; // Nova página de Área de Coleta
//
// class HomeAdmPage extends StatefulWidget {
//   @override
//   _HomeAdmPageState createState() => _HomeAdmPageState();
// }
//
// class _HomeAdmPageState extends State<HomeAdmPage> {
//   int _selectedIndex = 0;
//   final user = UserSession();
//
//   final List<Widget> _pages = [
//     HomeAdmPage(),
//     // AreaColetaPage(),
//     EnderecosPage(),
//     HomeColetaPage(),
//     NearbyItemsPage(),
//   ];
//
//
//
//   void _onItemTapped(int index) {
//     if (index != _selectedIndex) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => _pages[index]),
//       ).then((_) {
//         setState(() {
//           _selectedIndex = index;
//         });
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: CustomAppBarADM(user: user),
//       body: Stack(
//         children: [
//           // Imagem de fundo
//           Positioned.fill(
//             child: Image.asset(
//               'assets/fundoHome.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Conteúdo da página
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 80),
//                 Center(
//                   child: Column(
//                     children: [
//                       // Botão "Iniciar Coleta"
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AreaColetaPage(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 15,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: const Text(
//                           'Iniciar coleta',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       // Botão "Ver Itens"
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => HomeColetaPage(),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 15,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         child: const Text(
//                           'Ver Itens',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: const Color.fromARGB(255, 46, 50, 46),
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.white54,
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, size: 40),
//             label: 'Início',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.location_on, size: 40),
//             label: 'Área de Coleta',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.assignment, size: 40),
//             label: 'Ver Itens',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, size: 40),
//             label: 'Perfil',
//           ),
//         ],
//       ),
//     );
//   }
// }