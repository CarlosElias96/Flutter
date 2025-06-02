import 'package:flutter/material.dart';
import '../models/actividad.dart';
import '../baseDatos/bd_crud.dart';

class ActivityEditPage extends StatefulWidget {
  final Actividad actividad;

  const ActivityEditPage({super.key, required this.actividad});

  @override
  State<ActivityEditPage> createState() => _ActivityEditPageState();
}

class _ActivityEditPageState extends State<ActivityEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Precargar los datos en los campos
    _nombreController.text = widget.actividad.nombre;
    _apellidoController.text = widget.actividad.apellido;
    _edadController.text = widget.actividad.edad.toString();
    _emailController.text = widget.actividad.email;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _edadController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _actualizarActividad() async {
    if (_formKey.currentState!.validate()) {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Actualizando...'),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      final actividadActualizada = Actividad(
        id: widget.actividad.id,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        edad: int.parse(_edadController.text),
        email: _emailController.text,
      );

      await BDActividad().actualizarActividad(actividadActualizada);

      if (context.mounted) Navigator.of(context).pop(); // Cerrar diálogo

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad actualizada correctamente')),
      );

      Navigator.of(context).pop(); // Volver a pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Actividad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _actualizarActividad,
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
