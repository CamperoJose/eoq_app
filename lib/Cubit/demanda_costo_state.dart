// demanda_costo_state.dart
part of 'demanda_costo_cubit.dart';

@immutable
class DemandaCostoState {
  final double? demanda;
  final double? costoPedido;

  const DemandaCostoState({this.demanda, this.costoPedido});
}
