import 'dart:math' as math;

class EoqBasico {
  
  double calcularQ(double D, double h, double k) {
    // D: demanda anual, h: costo de mantener inventario por unidad por u de tiempo, k: costo de realizar un pedido
    final Q = math.sqrt((2 * D * k) / h);
    return double.parse(Q.toStringAsFixed(4));
  }

  double calcularT(double D, double Q) {
    // D: demanda anual, Q: cantidad óptima de pedido
    final t = Q / D;
    return double.parse(t.toStringAsFixed(4));
  }

  double calcularN(double T) {
    // T: tiempo entre pedidos
    final N = 1 / T;
    return double.parse(N.toStringAsFixed(4));
  }

  double calcularCostoTotal(double k, double C, double Q, double h, double D) {
    // k: costo de realizar un pedido, C: costo por unidad, Q: cantidad óptima de pedido
    // h: costo de mantener inventario por unidad por u de tiempo, D: demanda 
    final T = (D * k) / Q + D * C + (h * Q) / 2;
    return double.parse(T.toStringAsFixed(4));
  }
}
