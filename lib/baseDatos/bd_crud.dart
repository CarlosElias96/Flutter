import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/actividad.dart';

class BDActividad {
  static final BDActividad _instancia = BDActividad._();
  static Database? _baseDatos;

  Future<void> actualizarActividad(Actividad actividad) async {
  final db = await baseDatos;
  await db.update(
    'actividad',
    actividad.toMap(),
    where: 'id = ?',
    whereArgs: [actividad.id],
  );
}

  Future<void> eliminarActividad(int id) async {
    final db = await baseDatos;
    await db.delete('actividad', where: 'id = ?', whereArgs: [id]);
  }


  // Versión de la base de datos
  // Aqui realizaremos todas las peticiones que se deseene
  static const int _versionBD = 1; 

  BDActividad._();

  factory BDActividad() {
    return _instancia;
  }

  Future<Database> get baseDatos async {
    if (_baseDatos != null) return _baseDatos!;
    _baseDatos = await _iniciarBD();
    return _baseDatos!;
  }

  // Método para iniciar la base de datos
  Future<Database> _iniciarBD() async {
    final pathBD = join(await getDatabasesPath(), 'Actividad.db');
    return openDatabase(
      pathBD,
      version: _versionBD,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsuarios() async {
  final db = await baseDatos;
  return await db.query('usuarios'); // 'usuarios' nombre de la tabla
  }

  Future<List<Actividad>> getActividad() async {
  final db = await baseDatos;  // Asumiendo que tengo el getter database
  final List<Map<String, dynamic>> maps = await db.query('actividad'); // o el nombre que tengas de tabla

  return List.generate(maps.length, (i) {
    return Actividad.fromMap(maps[i]);
  });
}



  //  Crear la tabla en la primera ejecución
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ACTIVIDAD (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellido TEXT NOT NULL,
        edad INTEGER NOT NULL,
        email TEXT NOT NULL
      )
    ''');
  }

  // Método llamado si cambias la versión de la BD
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // En producción, usa alter table o migración controlada.
    // Aquí se borra y se vuelve a crear para ejemplo simple.
    await db.execute('DROP TABLE IF EXISTS ACTIVIDAD');
    await _onCreate(db, newVersion);
  }

  // Método para insertar
  Future<int> insertarActividad(Actividad actividad) async {
    final db = await baseDatos;
    return await db.insert('actividad', actividad.toMap());
  }

  // (Opcional) Otros métodos: obtener, actualizar, eliminar...
}

