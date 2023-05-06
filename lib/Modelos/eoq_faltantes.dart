import 'dart:math';

class EoqConFaltantes {
  // Variables requeridas: D, k, h, c, l, p (DEMANDA, COSTO DE PEDIDO, COSTO DE INVENTARIO, COSTO DE UNIDAD, COSTO DE FALTANTE, COSTO DE SOBRANTE)

  // Función para calcular la cantidad óptima de pedido (Q) en el modelo EOQ con faltantes
  double calcularQ(double D, double h, double k, double p) {
    // D: demanda , h: costo de mantener inventario por unidad por u de tiempo, k: costo de realizar un pedido, p: costo de faltante por unidad por u de tiempo
    double Q = sqrt((2 * D * k) / h) * sqrt(((p + h) / (p)));
    return double.parse(Q.toStringAsFixed(4));
  }

  // Función para calcular el punto de reorden (S) en el modelo EOQ con faltantes
  double calcularS(double D, double h, double k, double p) {
    // D: demanda , h: costo de mantener inventario por unidad por u de tiempo, k: costo de realizar un pedido, p: costo de faltante por unidad por u de tiempo
    double Q = sqrt((2 * D * k) / h) * sqrt(((p) / (p + h)));
    return double.parse(Q.toStringAsFixed(4));
  }

  // Función para calcular el tiempo entre pedidos (T) en el modelo EOQ con faltantes
  double calcularT(double D, double Q) {
    // D: demanda , Q: cantidad óptima de pedido
    double t = Q / D;
    return double.parse(t.toStringAsFixed(4));
  }

  // Función para calcular el número de pedidos por u de tiempo (N) en el modelo EOQ con faltantes
  double calcularN(double T) {
    // T: tiempo entre pedidos
    double N = 1 / T;
    return double.parse(N.toStringAsFixed(4));
  }

  // Función para calcular el faltante máximo en el modelo EOQ con faltantes
  double calcularFaltanteMaximo(double Q, double S) {
    // Q: cantidad óptima de pedido, S: punto de reorden
    double F = Q - S;
    return double.parse(F.toStringAsFixed(4));
  }

  // Función para calcular el costo total de inventario en el modelo EOQ con faltantes
  double calcularCostoTotal(
      double k, double C, double Q, double h, double D, double S, double P) {
    // k: costo de realizar un pedido, C: costo por unidad, Q: cantidad óptima de pedido
    // h: costo de mantener inventario por unidad por u de tiempo, D: demanda , S: punto de reorden, P: costo de faltante por unidad por u de tiempo
    double CT = (D * k) / Q +
        D * C +
        (h * S * S) / (2 * Q) +
        (P * (Q - S) * (Q - S)) / (2 * Q);
    return double.parse(CT.toStringAsFixed(4));
  }
}
