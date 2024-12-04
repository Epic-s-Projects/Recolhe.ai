import 'package:exemplo_firebase/screens/login_screen_view.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Configuração da animação
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Animação de escala
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0)
        .chain(CurveTween(curve: Curves.easeOutExpo))
        .animate(_controller);

    // Animação de opacidade
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);

    // Inicia a animação
    _controller.forward();

    // Após 3 segundos, navega para a próxima tela
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5E6CC), Color(0xFFF1D9B4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Image.asset(
                        'assets/recycle_icon.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.translate(
                      offset: Offset(
                          0, 50 * (1 - _opacityAnimation.value)), // Movimento
                      child: Image.asset(
                        'assets/folhas.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Texto de boas-vindas com opacidade
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Text(
                        "Recicle para um amanhã melhor.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.lightGreen,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:exemplo_firebase/screens/login_screen_view.dart';
// import 'package:flutter/material.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Configuração da animação
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     );
//
//     // Animação de escala (ícone principal)
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
//         .chain(CurveTween(curve: Curves.easeOutExpo))
//         .animate(_controller);
//
//     // Animação de opacidade (elementos visuais)
//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
//         .chain(CurveTween(curve: Curves.easeInOut))
//         .animate(_controller);
//
//     // Animação de deslizar (folhas na base)
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).chain(CurveTween(curve: Curves.easeOutQuint)).animate(_controller);
//
//     // Inicia a animação
//     _controller.forward();
//
//     // Navega para a próxima tela após 3 segundos
//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const LoginScreen(),
//         ),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF2C5364), Color(0xFF0F2027)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Ícone central com animação de escala e opacidade
//             Center(
//               child: AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _scaleAnimation.value,
//                     child: Opacity(
//                       opacity: _opacityAnimation.value,
//                       child: Image.asset(
//                         'assets/recycle_icon.png',
//                         width: 150,
//                         height: 150,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // Texto de boas-vindas com opacidade
//             Align(
//               alignment: Alignment.center,
//               child: AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   return Opacity(
//                     opacity: _opacityAnimation.value,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 200),
//                       child: Text(
//                         "Recycle for a Better Tomorrow",
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // Folhas na base deslizando suavemente
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   return SlideTransition(
//                     position: _slideAnimation,
//                     child: Opacity(
//                       opacity: _opacityAnimation.value,
//                       child: Image.asset(
//                         'assets/folhas.png',
//                         width: MediaQuery.of(context).size.width,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
