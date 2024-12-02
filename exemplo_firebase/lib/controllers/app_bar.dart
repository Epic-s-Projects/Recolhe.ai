import 'package:exemplo_firebase/screens/administrador/profile_adm_page.dart';
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: const Color(0xFF4CAF50), // Verde moderno e suave
      automaticallyImplyLeading: false, // Remove a seta de voltar
      title: Text(
        'Olá, ${user.name ?? 'Usuário'}!',
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.w600,
          color: Colors.white, // Verde suave
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.04),
          child: GestureDetector(
            onTap: () {
              print("O nome é: ${user.name}");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const ProfileScreenADM(),
              //   ),
              // );
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
