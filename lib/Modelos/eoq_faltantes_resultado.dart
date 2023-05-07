class EoqFaltantesResultado {
  int? id;
  int productoId;
  double cantidadOptima;
  double nivelMaximo;
  double tiempoCiclo;
  double numeroCiclo;
  double faltante;
  double costoTotal;

  EoqFaltantesResultado({
    this.id,
    required this.productoId,
    required this.cantidadOptima,
    required this.nivelMaximo,
    required this.tiempoCiclo,
    required this.numeroCiclo,
    required this.faltante,
    required this.costoTotal,
  });

  // Convertir un objeto EoqFaltantes en un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'producto_id': productoId,
      'cantidad_optima': cantidadOptima,
      'nivel_maximo': nivelMaximo,
      'tiempo_ciclo': tiempoCiclo,
      'numero_ciclo': numeroCiclo,
      'faltante': faltante,
      'costo_total': costoTotal,
    };
  }

  // Crear un objeto EoqFaltantes a partir de un Map
  factory EoqFaltantesResultado.fromMap(Map<String, dynamic> map) {
    return EoqFaltantesResultado(
      id: map['id'],
      productoId: map['producto_id'],
      cantidadOptima: map['cantidad_optima'],
      nivelMaximo: map['nivel_maximo'],
      tiempoCiclo: map['tiempo_ciclo'],
      numeroCiclo: map['numero_ciclo'],
      faltante: map['faltante'],
      costoTotal: map['costo_total'],
    );
  }
}
