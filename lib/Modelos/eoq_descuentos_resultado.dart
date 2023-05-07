class EoqDescuentosResultado {
  int? id;
  int productoId;
  double cantidadOptima;
  double? cantidadOrdenar;
  double? costoPorOrdenar;
  double? costoPedido;
  double? costoMantenimiento;
  double? costoTotal;

  EoqDescuentosResultado({
    this.id,
    required this.productoId,
    required this.cantidadOptima,
    required this.cantidadOrdenar,
    required this.costoPorOrdenar,
    required this.costoPedido,
    required this.costoMantenimiento,
    required this.costoTotal,
  });

  // Convertir un objeto EoqDescuentos en un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'producto_id': productoId,
      'cantidad_optima': cantidadOptima,
      'cantidad_ordenar': cantidadOrdenar,
      'costo_por_ordenar': costoPorOrdenar,
      'costo_pedido': costoPedido,
      'costo_mantenimiento': costoMantenimiento,
      'costo_total': costoTotal,
    };
  }

  // Crear un objeto EoqDescuentos a partir de un Map
  factory EoqDescuentosResultado.fromMap(Map<String, dynamic> map) {
    return EoqDescuentosResultado(
      id: map['id'],
      productoId: map['producto_id'],
      cantidadOptima: map['cantidad_optima'],
      cantidadOrdenar: map['cantidad_ordenar'],
      costoPorOrdenar: map['costo_por_ordenar'],
      costoPedido: map['costo_pedido'],
      costoMantenimiento: map['costo_mantenimiento'],
      costoTotal: map['costo_total'],
    );
  }
}
