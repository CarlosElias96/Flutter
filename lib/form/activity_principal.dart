import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_button/animated_button.dart';
import 'activity_second.dart';
import 'activity_lista_persona.dart';

class nuevaPagina extends StatefulWidget {
  const nuevaPagina({super.key});

  @override
  State<nuevaPagina> createState() => _nuevaPaginaState();
}

class _nuevaPaginaState extends State<nuevaPagina> {
  // Mostrar diálogo de cargando
  void mostrarProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // No se puede cerrar tocando fuera
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Cargando...'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Prueba de páginas',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/images.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),

                // 👉 Botón con progreso y navegación
                AnimatedButton(
                  child: const Text(
                    'Ir al viaje',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  color: Colors.white,
                  width: 200,
                  height: 50,
                  onPressed: () async {
                    mostrarProgressDialog(context); // mostrar loading
                    await Future.delayed(const Duration(seconds: 2)); // simula espera
                    if (mounted) Navigator.of(context, rootNavigator: true).pop(); // cerrar loading
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ActivitySecond()),
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),

                // 👉 Otro botón con mismo comportamiento
                AnimatedButton(
                  child: const Text(
                    'Ir a DB Datos',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  color: Colors.white,
                  width: 200,
                  height: 50,
                  onPressed: () async {
                    mostrarProgressDialog(context);
                    await Future.delayed(const Duration(seconds: 2));
                    if (mounted) Navigator.of(context, rootNavigator: true).pop();
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DbDatos()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
