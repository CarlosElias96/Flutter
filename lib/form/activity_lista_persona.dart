import 'package:flutter/material.dart';
import '../baseDatos/bd_crud.dart';
import '../models/actividad.dart';
import '../globales/globales.dart';
import 'activity_editar_persona.dart';
import 'activity_second.dart';

class DbDatos extends StatefulWidget {
  const DbDatos({Key? key}) : super(key: key);

  @override
  State<DbDatos> createState() => _DbDatosState();
}

class _DbDatosState extends State<DbDatos> {
  late Future<List<Actividad>> actividadesFuture;

  @override
  void initState() {
    super.initState();
    actividadesFuture = BDActividad().getActividad();
  }

//subiendo datos al main
  bool _formChanged = false;

  Future<bool> _onWillPop() async {
    if (!_formChanged) return true;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Salir sin guardar?'),
        content: const Text('Hay cambios sin guardar. ¿Seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  void _confirmarEdicion(Actividad actividad) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Actividad'),
      content: const Text('¿Deseas editar esta actividad?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancelar
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Cierra el diálogo
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityEditPage(actividad: actividad),
              ),
            );
            setState(() {
              actividadesFuture = baseDatosGlobal.getActividad();
            });
          },
          child: const Text('Sí, editar'),
        ),
      ],
    ),
  );
}


  void _confirmarNavegacionACrear() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear nueva actividad'),
        content: const Text('¿Deseas ir a la pantalla para agregar una nueva actividad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // cerrar diálogo
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivitySecond()),
              );
              setState(() {
                actividadesFuture = baseDatosGlobal.getActividad();
              });
            },
            child: const Text('Sí, ir'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminacion(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Actividad'),
        content: const Text('¿Estás seguro de que deseas eliminar esta actividad?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await BDActividad().eliminarActividad(id);
              Navigator.of(context).pop();
              setState(() {
                actividadesFuture = baseDatosGlobal.getActividad();
              });
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Actividades'),
        ),
        body: FutureBuilder<List<Actividad>>(
          future: actividadesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay actividades guardadas.'));
            }

            final actividades = snapshot.data!;
            return ListView.builder(
              itemCount: actividades.length,
              itemBuilder: (context, index) {
                final actividad = actividades[index];
                return ListTile(
                  title: Text('${actividad.nombre} ${actividad.apellido}'),
                  subtitle: Text('Edad: ${actividad.edad}, Email: ${actividad.email}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _confirmarEdicion(actividad),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarEliminacion(actividad.id!),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _confirmarNavegacionACrear,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
