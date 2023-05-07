import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'eoq_descuentos_state.dart';

class EoqDescuentosCubit extends Cubit<EoqDescuentosState> {
  EoqDescuentosCubit() : super(EoqDescuentosState(calculoQ: 0.00));

  void updateAll(
    double calculoQ,
    double cantidadOrdenar,
    double costoPorOrdenar,
    double costoAnualPedido,
    double costoAnualMantenimiento,
    double costoTotal,
  ) {
    emit(EoqDescuentosState(
      calculoQ: calculoQ,
      cantidadOrdenar: cantidadOrdenar,
      costoPorOrdenar: costoPorOrdenar,
      costoAnualPedido: costoAnualPedido,
      costoAnualMantenimiento: costoAnualMantenimiento,
      costoTotal: costoTotal,
    ));
  }

  void reset() {
    emit(EoqDescuentosState(calculoQ: 0.00));
  }
}
