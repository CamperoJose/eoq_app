// demanda_costo_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'demanda_costo_state.dart';


class DemandaCostoCubit extends Cubit<DemandaCostoState> {
  DemandaCostoCubit() : super(DemandaCostoState());

  void updateDemanda(double demanda) {
    emit(DemandaCostoState(demanda: demanda, costoPedido: state.costoPedido));
  }

  void updateCostoPedido(double costoPedido) {
    emit(DemandaCostoState(demanda: state.demanda, costoPedido: costoPedido));
  }

  void reset() {
    emit(DemandaCostoState());
  }
}

