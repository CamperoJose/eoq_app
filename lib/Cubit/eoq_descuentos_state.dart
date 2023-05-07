part of 'eoq_descuentos_cubit.dart';

@immutable
class EoqDescuentosState {
  final double? calculoQ;
  final double? cantidadOrdenar;
  final double? costoPorOrdenar;
  final double? costoAnualPedido;
  final double? costoAnualMantenimiento;
  final double? costoTotal;

  EoqDescuentosState({
    this.calculoQ,
    this.cantidadOrdenar,
    this.costoPorOrdenar,
    this.costoAnualPedido,
    this.costoAnualMantenimiento,
    this.costoTotal,
  });
}


