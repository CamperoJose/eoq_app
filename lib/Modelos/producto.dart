class Producto {
  int? id;
  int proveedorId;
  String nombre;
  String descripcion;
  double precioVenta;

  Producto({
    this.id,
    required this.proveedorId,
    required this.nombre,
    required this.descripcion,
    required this.precioVenta,
  });

  // Convertir un objeto Producto en un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'proveedor_id': proveedorId,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_venta': precioVenta,
    };
  }

  // Crear un objeto Producto a partir de un Map
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      proveedorId: map['proveedor_id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precioVenta: map['precio_venta'],
    );
  }
}
