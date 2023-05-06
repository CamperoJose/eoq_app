class Producto {
  int? id;
  String nombre;
  String descripcion;
  double precioVenta;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioVenta,
  });

  // Convertir un objeto Producto en un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_venta': precioVenta,
    };
  }

  // Crear un objeto Producto a partir de un Map
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precioVenta: map['precio_venta'],
    );
  }
}
