class Actividad {
  int? id; // Opcional para cuando aún no se guarda en la BD
  final String nombre;
  final String apellido;
  final int edad;
  final String email;

  Actividad({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.email,
  });

  // Convertir objeto a mapa para SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'edad': edad,
      'email': email,
    };
  }

  

  // Crear objeto desde un mapa de SQLite
  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      id: map['id'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      edad: map['edad'],
      email: map['email'],
    );
  }
}
