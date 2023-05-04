import 'dart:math' as math;

class EoqDescuentos {
  // Función para calcular Q óptimo
  double calculoQ(double D, double k, double i, double RCOSTO) {
    final ans = math.sqrt((2 * D * k) / (i * RCOSTO));
    return double.parse(ans.toStringAsFixed(2));
  }

  // Función para determinar cantidad a ordenar dentro del rango dado
  double cantidadOrdenar(double Q, double RDESDE, double RHASTA) {
    var q = Q;
    if (Q < RDESDE) {
      q = RDESDE;
    } else if (Q > RHASTA) {
      q = RHASTA;
    }
    return q;
  }

  // Función para calcular costo de ordenar
  double costoPorOrdenar(double D, double C) {
    final ans = D * C;
    return double.parse(ans.toStringAsFixed(2));
  }

  // Función para calcular costo anual de pedido
  double costoAnualPedido(double D, double k, double qR) {
    final ans = (D * k) / qR;
    return double.parse(ans.toStringAsFixed(2));
  }

  // Función para calcular costo anual de mantenimiento
  double costoAnualMantenimiento(double C, double i, double qR) {
    final ans = (qR * i * C) / 2;
    return double.parse(ans.toStringAsFixed(2));
  }

  // Función para calcular costo total
  double costoTotal(double C1, double C2, double C3) {
    final ans = C1 + C2 + C3;
    return double.parse(ans.toStringAsFixed(2));
  }
}
