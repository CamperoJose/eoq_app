class EoqBasicoResultado {
  int? id;
  int productoId;
  double cantidadOptima;
  double tiempoCiclo;
  double numeroCiclo;
  double costoTotal;

  EoqBasicoResultado({
    this.id,
    required this.productoId,
    required this.cantidadOptima,
    required this.tiempoCiclo,
    required this.numeroCiclo,
    required this.costoTotal,
  });

  // Convertir un objeto EOQ en un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'producto_id': productoId,
      'cantidad_optima': cantidadOptima,
      'tiempo_ciclo': tiempoCiclo,
      'numero_ciclo': numeroCiclo,
      'costo_total': costoTotal,
    };
  }

  // Crear un objeto EOQ a partir de un Map
  factory EoqBasicoResultado.fromMap(Map<String, dynamic> map) {
    return EoqBasicoResultado(
      id: map['id'],
      productoId: map['producto_id'],
      cantidadOptima: map['cantidad_optima'],
      tiempoCiclo: map['tiempo_ciclo'],
      numeroCiclo: map['numero_ciclo'],
      costoTotal: map['costo_total'],
    );
  }
}
