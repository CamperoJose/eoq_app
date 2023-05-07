import 'package:eoq_app/Modelos/eoq_descuentos.dart';
import 'package:eoq_app/UI/calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'dart:math';
import '../Componentes/text_field2.dart';
import '../Cubit/demanda_costo_cubit.dart';
import '../Cubit/eoq_descuentos_cubit.dart';

class EoqDescuentosForm extends StatefulWidget {
  @override
  _EoqDescuentosFormState createState() => _EoqDescuentosFormState();
}

class _EoqDescuentosFormState extends State<EoqDescuentosForm> {
  TextEditingController costoMantenerController = TextEditingController();
  TextEditingController rango1InicioController = TextEditingController();
  TextEditingController rango1FinController = TextEditingController();
  TextEditingController rango1CostoUnitarioController = TextEditingController();
  TextEditingController rango2InicioController = TextEditingController();
  TextEditingController rango2FinController = TextEditingController();
  TextEditingController rango2CostoUnitarioController = TextEditingController();
  TextEditingController rango3InicioController = TextEditingController();
  TextEditingController rango3FinController = TextEditingController();
  TextEditingController rango3CostoUnitarioController = TextEditingController();

  List<double> CalculosEoqDescuentoRango1 = [0, 0, 0, 0, 0, 0];
  List<double> CalculosEoqDescuentoRango2 = [0, 0, 0, 0, 0, 0];
  List<double> CalculosEoqDescuentoRango3 = [0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EOQ con descuentos'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallpaper01.png'),
                fit: BoxFit.cover, // o BoxFit.contain
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  int columnCount = 1;
                  if (constraints.maxWidth >= 800) {
                    columnCount = 2;
                  }
                  return BootstrapContainer(
                    fluid: true,
                    children: [
                      BootstrapRow(
                        children: [
                          BootstrapCol(
                            sizes: 'col-${12 ~/ columnCount}',
                            child: _buildInventarioEoqBasicoForm(),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventarioEoqBasicoForm() {
    // Accede al cubit
    final demandaCostoCubit = context.watch<DemandaCostoCubit>();
    // Extrae los valores del estado
    final demanda = demandaCostoCubit.state.demanda;
    final costoPedido = demandaCostoCubit.state.costoPedido;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextInputForm(
                controller: costoMantenerController,
                labelText: 'i: Tasa de costo de mantener inventario',
                prefixIcon: Icons.trending_up,
              ),
              const SizedBox(height: 24),
              // Rango 1
              const Text('Rango 1:'),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango1InicioController,
                labelText: 'Rango 1 (inicio)',
                prefixIcon: Icons.low_priority,
              ),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango1FinController,
                labelText: 'Rango 1 (fin)',
                prefixIcon: Icons.high_quality,
              ),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango1CostoUnitarioController,
                labelText: 'Costo Unitario',
                prefixIcon: Icons.monetization_on,
              ),
              const SizedBox(height: 24),
              // Rango 2
              const Text('Rango 2:'),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango2InicioController,
                labelText: 'Rango 2 (inicio)',
                prefixIcon: Icons.low_priority,
              ),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango2FinController,
                labelText: 'Rango 2 (fin)',
                prefixIcon: Icons.high_quality,
              ),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango2CostoUnitarioController,
                labelText: 'Costo Unitario',
                prefixIcon: Icons.monetization_on,
              ),
              const SizedBox(height: 24),
              // Rango 3
              const Text('Rango 3:'),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango3InicioController,
                labelText: 'Rango 3 (inicio)',
                prefixIcon: Icons.low_priority,
              ),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango3FinController,
                labelText: 'Rango 3 (fin)',
                prefixIcon: Icons.high_quality,
              ),
              const SizedBox(height: 8),
              TextInputForm(
                controller: rango3CostoUnitarioController,
                labelText: 'Costo Unitario',
                prefixIcon: Icons.monetization_on,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    EoqDescuentos calcularDescuentos = EoqDescuentos();
                    setState(() {
                      // si los controladores no estan vacios
                      if (costoMantenerController.text.isNotEmpty &&
                          rango1InicioController.text.isNotEmpty &&
                          rango1FinController.text.isNotEmpty &&
                          rango1CostoUnitarioController.text.isNotEmpty &&
                          rango2InicioController.text.isNotEmpty &&
                          rango2FinController.text.isNotEmpty &&
                          rango2CostoUnitarioController.text.isNotEmpty &&
                          rango3InicioController.text.isNotEmpty &&
                          rango3FinController.text.isNotEmpty &&
                          rango3CostoUnitarioController.text.isNotEmpty) {
                        // se calcula el EOQ con descuentos
                        if (demanda != null && costoPedido != null) {
                          // calculoQ
                          CalculosEoqDescuentoRango1[0] =
                              calcularDescuentos.calculoQ(
                            demanda,
                            costoPedido,
                            double.parse(costoMantenerController.text),
                            double.parse(rango1CostoUnitarioController.text),
                          );
                          CalculosEoqDescuentoRango2[0] =
                              calcularDescuentos.calculoQ(
                            demanda,
                            costoPedido,
                            double.parse(costoMantenerController.text),
                            double.parse(rango2CostoUnitarioController.text),
                          );
                          CalculosEoqDescuentoRango3[0] =
                              calcularDescuentos.calculoQ(
                            demanda,
                            costoPedido,
                            double.parse(costoMantenerController.text),
                            double.parse(rango3CostoUnitarioController.text),
                          );
                          // cantidadOrdenar
                          CalculosEoqDescuentoRango1[1] =
                              calcularDescuentos.cantidadOrdenar(
                            CalculosEoqDescuentoRango1[0],
                            double.parse(rango1InicioController.text),
                            double.parse(rango1FinController.text),
                          );
                          CalculosEoqDescuentoRango2[1] =
                              calcularDescuentos.cantidadOrdenar(
                            CalculosEoqDescuentoRango2[0],
                            double.parse(rango2InicioController.text),
                            double.parse(rango2FinController.text),
                          );
                          CalculosEoqDescuentoRango3[1] =
                              calcularDescuentos.cantidadOrdenar(
                            CalculosEoqDescuentoRango3[0],
                            double.parse(rango3InicioController.text),
                            double.parse(rango3FinController.text),
                          );
                          // costoPorOrdenar
                          CalculosEoqDescuentoRango1[2] =
                              calcularDescuentos.costoPorOrdenar(
                            demanda,
                            double.parse(rango1CostoUnitarioController.text),
                          );
                          CalculosEoqDescuentoRango2[2] =
                              calcularDescuentos.costoPorOrdenar(
                            demanda,
                            double.parse(rango2CostoUnitarioController.text),
                          );
                          CalculosEoqDescuentoRango3[2] =
                              calcularDescuentos.costoPorOrdenar(
                            demanda,
                            double.parse(rango3CostoUnitarioController.text),
                          );
                          // costoAnualPedido
                          CalculosEoqDescuentoRango1[3] =
                              calcularDescuentos.costoAnualPedido(
                            demanda,
                            costoPedido,
                            CalculosEoqDescuentoRango1[1],
                          );
                          CalculosEoqDescuentoRango2[3] =
                              calcularDescuentos.costoAnualPedido(
                            demanda,
                            costoPedido,
                            CalculosEoqDescuentoRango2[1],
                          );
                          CalculosEoqDescuentoRango3[3] =
                              calcularDescuentos.costoAnualPedido(
                            demanda,
                            costoPedido,
                            CalculosEoqDescuentoRango3[1],
                          );
                          // costoAnualMantener
                          CalculosEoqDescuentoRango1[4] =
                              calcularDescuentos.costoAnualMantenimiento(
                            double.parse(rango1CostoUnitarioController.text),
                            double.parse(costoMantenerController.text),
                            CalculosEoqDescuentoRango1[0],
                          );
                          CalculosEoqDescuentoRango2[4] =
                              calcularDescuentos.costoAnualMantenimiento(
                            double.parse(rango2CostoUnitarioController.text),
                            double.parse(costoMantenerController.text),
                            CalculosEoqDescuentoRango2[0],
                          );
                          CalculosEoqDescuentoRango3[4] =
                              calcularDescuentos.costoAnualMantenimiento(
                            double.parse(rango3CostoUnitarioController.text),
                            double.parse(costoMantenerController.text),
                            CalculosEoqDescuentoRango3[0],
                          );
                          // costoTotal
                          CalculosEoqDescuentoRango1[5] =
                              calcularDescuentos.costoTotal(
                            CalculosEoqDescuentoRango1[2],
                            CalculosEoqDescuentoRango1[3],
                            CalculosEoqDescuentoRango1[4],
                          );
                          CalculosEoqDescuentoRango2[5] =
                              calcularDescuentos.costoTotal(
                            CalculosEoqDescuentoRango2[2],
                            CalculosEoqDescuentoRango2[3],
                            CalculosEoqDescuentoRango2[4],
                          );
                          CalculosEoqDescuentoRango3[5] =
                              calcularDescuentos.costoTotal(
                            CalculosEoqDescuentoRango3[2],
                            CalculosEoqDescuentoRango3[3],
                            CalculosEoqDescuentoRango3[4],
                          );
                        }
                        // get the lower of the three in index 5
                        List<double> listaCostos = [
                          CalculosEoqDescuentoRango1[5],
                          CalculosEoqDescuentoRango2[5],
                          CalculosEoqDescuentoRango3[5]
                        ];
                        double minValue = min(
                            min(listaCostos[0], listaCostos[1]),
                            listaCostos[2]);
                        int index = listaCostos.indexOf(minValue);

                        // Crear una lista de listas que contenga las tres listas de cálculos
                        List<List<double>> allCalculations = [
                          CalculosEoqDescuentoRango1,
                          CalculosEoqDescuentoRango2,
                          CalculosEoqDescuentoRango3,
                        ];

                        // Seleccionar la lista con el costo más bajo usando el índice del valor mínimo
                        List<double> lowestCostCalculations =
                            allCalculations[index];

                        // Actualizar el cubit con los valores de la lista con el costo más bajo
                        context.read<EoqDescuentosCubit>().updateAll(
                              lowestCostCalculations[0],
                              lowestCostCalculations[1],
                              lowestCostCalculations[2],
                              lowestCostCalculations[3],
                              lowestCostCalculations[4],
                              lowestCostCalculations[5],
                            );
                        
                        // Navegar a la pagina anterior con un pop
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: const Text('Calcular')),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
