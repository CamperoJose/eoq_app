import 'dart:math' as math;


class EoqFaltantes {
  double calculoQ(double D, double k, double i, double RCOSTO) {
    double ans = math.sqrt((2 * D * k) / (i * RCOSTO));
    return double.parse(ans.toStringAsFixed(2));
  }

  double cantidadOrdenar(double Q, double RDESDE, double RHASTA) {
    double q = Q;
    if (Q < RDESDE) {
      q = RDESDE;
    } else if (Q > RHASTA) {
      q = RHASTA;
    }
    return q;
  }

  double costoPorOrdenar(double D, double C) {
    double ans = D * C;
    return double.parse(ans.toStringAsFixed(2));
  }

  double costoAnualPedido(double D, double k, double qR) {
    double ans = (D * k) / qR;
    return double.parse(ans.toStringAsFixed(2));
  }

  double costoAnualMantenimiento(double C, double i, double qR) {
    double ans = (qR * i * C) / 2;
    return double.parse(ans.toStringAsFixed(2));
  }

  double costoTotal(double C1, double C2, double C3) {
    double ans = C1 + C2 + C3;
    return double.parse(ans.toStringAsFixed(2));
  }
}
