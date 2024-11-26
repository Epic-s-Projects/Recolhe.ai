import 'package:exemplo_firebase/screens/intern_screen_view.dart';
import 'package:flutter/material.dart';
import '../controllers/user_data.dart';
import '../screens/profile_screen_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserSession user;
  final bool showBackButton;

  const CustomAppBar({
    required this.user,
    this.showBackButton = false, // Por padrão, a seta não será exibida
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: Colors.green,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: const Color(0xFF38783B), // Verde suave
          size: screenWidth * 0.06,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );// Volta para a página anterior
        },
      )
          : null, // Sem botão caso `showBackButton` seja falso
      title: Text(
        'Olá, ${user.name ?? 'Usuário'}',
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF38783B), // Verde suave
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.04),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: CircleAvatar(
              radius: screenWidth * 0.06,
              backgroundColor: Colors.grey.shade200,
              child: (user.imagem != null && user.imagem!.isNotEmpty)
                  ? ClipOval(
                child: Image.network(
                  user.imagem!,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                ),
              )
                  : Icon(
                Icons.person,
                size: screenWidth * 0.06,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
