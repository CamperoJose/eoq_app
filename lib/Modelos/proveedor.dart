class Proveedor {
  int? id;
  String nombre;
  String celular;
  String telefono;
  String correo;

  Proveedor({
    this.id,
    required this.nombre,
    required this.celular,
    required this.telefono,
    required this.correo,
  });

  // Convertir un objeto Proveedor en un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'celular': celular,
      'telefono': telefono,
      'correo': correo,
    };
  }

  // Crear un objeto Proveedor a partir de un Map
  factory Proveedor.fromMap(Map<String, dynamic> map) {
    return Proveedor(
      id: map['id'],
      nombre: map['nombre'],
      celular: map['celular'],
      telefono: map['telefono'],
      correo: map['correo'],
    );
  }
}
