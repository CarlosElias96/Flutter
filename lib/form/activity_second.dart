import 'package:flutter/material.dart';
import '../../models/actividad.dart';
import 'activity_lista_persona.dart';
import '../globales/globales.dart';


class ActivitySecond extends StatefulWidget {
  const ActivitySecond({super.key});

  @override
  State<ActivitySecond> createState() => _ActivitySecondState();
}

class _ActivitySecondState extends State<ActivitySecond> {
  final _formKey = GlobalKey<FormState>();
  bool _formChanged = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<bool> _onWillPop() async {
    if (!_formChanged) return true;
//variable == "" ? "" : "";
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir sin guardar?'),
        content: const Text('Hay cambios sin guardar. ¿Seguro que quieres salir?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Salir')),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  void _guardarActividad() async {
  if (_formKey.currentState!.validate()) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Guardando...'),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    final actividad = Actividad(
      nombre: _nombreController.text,
      apellido: _apellidoController.text,
      edad: int.parse(_edadController.text),
      email: _emailController.text,
    );

    await baseDatosGlobal.insertarActividad(actividad); // ← instancia global aquí

    if (context.mounted) Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Actividad guardada correctamente')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DbDatos()),
      (Route<dynamic> route) => false,
    );
  }
}



  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _edadController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Nueva Actividad')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() => _formChanged = true),
            child: Column(
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value!.isEmpty ? 'Ingrese un nombre' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator: (value) => value!.isEmpty ? 'Ingrese un apellido' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _edadController,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) return 'Ingrese la edad';
                    final edad = int.tryParse(value);
                    if (edad == null || edad <= 0) return 'Edad inválida';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) return 'Ingrese un email';
                    if (!value.contains('@')) return 'Email inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                
                ElevatedButton(
                onPressed: _guardarActividad,
                child: const Text('Guardar Actividad'),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
