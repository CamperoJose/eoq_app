import 'dart:math';

import 'package:eoq_app/UI/eoq_descuentos_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import '../Componentes/chat_gpt.dart';
import '../Componentes/statistics.dart';
import '../Componentes/text_field2.dart';
import '../Cubit/demanda_costo_cubit.dart';
import '../Cubit/eoq_descuentos_cubit.dart';
import '../Modelos/eoq_basico.dart';
import '../Modelos/eoq_faltantes.dart';

class CalculatorView extends StatefulWidget {
  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController correoController = TextEditingController();
  TextEditingController productoNombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController precioVentaController = TextEditingController();
  TextEditingController demandaController = TextEditingController();
  TextEditingController costoMantenerController = TextEditingController();
  TextEditingController costoPedidoController = TextEditingController();
  TextEditingController costoPorUnidadController = TextEditingController();
  TextEditingController costoFaltanteControler = TextEditingController();

  List<double> CalculosEoqBasico = [0, 0, 0, 0];
  List<double> CalculosEoqFaltantes = [0, 0, 0, 0, 0, 0];

  bool CalculoEoqBasico = false;
  bool CalculoEoqFaltantes = false;
  bool CalculoEoqDescuentos = false;

  void _updateDemanda() {
    final value = double.tryParse(demandaController.text) ?? 0.0;
    context.read<DemandaCostoCubit>().updateDemanda(value);
  }

  void _updateCostoPedido() {
    final value = double.tryParse(costoPedidoController.text) ?? 0.0;
    context.read<DemandaCostoCubit>().updateCostoPedido(value);
  }

  @override
  void initState() {
    super.initState();
    demandaController.addListener(_updateDemanda);
    costoPedidoController.addListener(_updateCostoPedido);
  }

  @override
  void dispose() {
    demandaController.removeListener(_updateDemanda);
    costoPedidoController.removeListener(_updateCostoPedido);

    demandaController.dispose();
    costoPedidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eoq_descuentos_cubit = context.watch<EoqDescuentosCubit>();
    final calculoQ = eoq_descuentos_cubit.state.calculoQ;
    final cantidadOrdenar = eoq_descuentos_cubit.state.cantidadOrdenar;
    final costoPorOrdenar = eoq_descuentos_cubit.state.costoPorOrdenar;
    final costoAnualPedido = eoq_descuentos_cubit.state.costoAnualPedido;
    final costoAnualMantenimiento =
        eoq_descuentos_cubit.state.costoAnualMantenimiento;
    final costoTotal = eoq_descuentos_cubit.state.costoTotal;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16,
                  ),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      int columnCount = 1;
                      if (constraints.maxWidth >= 800) {
                        columnCount = 3;
                      }
                      return BootstrapContainer(
                        fluid: true,
                        children: [
                          BootstrapRow(
                            children: [
                              BootstrapCol(
                                sizes: 'col-${12 ~/ columnCount}',
                                child: _buildProveedorForm(),
                              ),
                              BootstrapCol(
                                sizes: 'col-${12 ~/ columnCount}',
                                child: _buildProductoForm(),
                              ),
                              BootstrapCol(
                                sizes: 'col-${12 ~/ columnCount}',
                                child: _buildInventarioEoqBasicoForm(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          BootstrapRow(
                            children: [
                              BootstrapCol(
                                sizes: 'col-md-4 col-sm-12',
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "EOQ BASICO",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          !CalculoEoqBasico
                                              ? "Sin Datos Suficientes"
                                              : "Q: ${CalculosEoqBasico[0]} unidades\nT: ${CalculosEoqBasico[1]} meses\nN: ${CalculosEoqBasico[2]} pedidos\nCT: ${CalculosEoqBasico[3]} \$",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              BootstrapCol(
                                sizes: 'col-md-4 col-sm-12',
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "EOQ FALTANTES",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          !CalculoEoqFaltantes
                                              ? "Sin Datos Suficientes"
                                              : "Q: ${CalculosEoqFaltantes[0]} unidades\nS: ${CalculosEoqFaltantes[1]} unidades\nT: ${CalculosEoqFaltantes[2]} meses\nN: ${CalculosEoqFaltantes[3]} pedidos\nF. maximo: ${CalculosEoqFaltantes[4]} unidades\nCT: ${CalculosEoqFaltantes[5]} \$",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              BootstrapCol(
                                sizes: 'col-md-4 col-sm-12',
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "EOQ DESCUENTOS",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        (calculoQ == null ||
                                                cantidadOrdenar == null ||
                                                costoPorOrdenar == null ||
                                                costoAnualPedido == null ||
                                                costoAnualMantenimiento ==
                                                    null ||
                                                costoTotal == null)
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EoqDescuentosForm()));
                                                    CalculoEoqDescuentos = true;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Colors.orange,
                                                ),
                                                child: const Text(
                                                    "Agregar Cantidades"),
                                              )
                                            : Column(
                                                children: [
                                                  Text(
                                                    "Q: $calculoQ\n"
                                                    "Cantidad Ordenar: $cantidadOrdenar\n"
                                                    "Costo Por Ordenar: $costoPorOrdenar\n"
                                                    "Costo Anual Pedido: $costoAnualPedido\n"
                                                    "Costo Anual Mantenimiento: $costoAnualMantenimiento\n"
                                                    "Costo Total: $costoTotal",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: BootstrapContainer(
                              fluid: true,
                              children: [
                                BootstrapRow(
                                  children: [
                                    BootstrapCol(
                                      sizes: 'col-12 col-md-6',
                                      child: const ChatGPTMessage(
                                        message: 'Hola soy chatGPT',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // StatisticsGraph
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: StatisticsGraph(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildProveedorForm() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('Proveedor'),
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Form(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: nombreController,
                    labelText: 'Nombre',
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: celularController,
                    labelText: 'Celular',
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: telefonoController,
                    labelText: 'Teléfono',
                    prefixIcon: Icons.phone,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: correoController,
                    labelText: 'Correo',
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text('Agregar'),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductoForm() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('Producto'),
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Form(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: productoNombreController,
                    labelText: 'Nombre',
                    prefixIcon: Icons.local_offer,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: descripcionController,
                    labelText: 'Descripción',
                    prefixIcon: Icons.description,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: precioVentaController,
                    labelText: 'Precio de venta',
                    prefixIcon: Icons.attach_money,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventarioEoqBasicoForm() {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text('Inventario EOQ'),
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Form(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: demandaController,
                    labelText: 'D: Demanda',
                    prefixIcon: Icons.compare_arrows,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: costoMantenerController,
                    labelText: 'H: Costo de mantener',
                    prefixIcon: Icons.money,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: costoPedidoController,
                    labelText: 'K: Costo de realizar el pedido',
                    prefixIcon: Icons.local_shipping,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: costoPorUnidadController,
                    labelText: 'C: Costo por Unidad',
                    prefixIcon: Icons.production_quantity_limits_outlined,
                  ),
                  const SizedBox(height: 16),
                  TextInputForm(
                    controller: costoFaltanteControler,
                    labelText: 'P: Costo Faltante',
                    prefixIcon: Icons.expand_more_outlined,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      EoqBasico calcularQ = EoqBasico();
                      EoqConFaltantes calcularFaltantes = EoqConFaltantes();
                      setState(() {
                        if (demandaController != null &&
                            costoMantenerController != null &&
                            costoPedidoController != null &&
                            costoPorUnidadController != null) {
                          CalculoEoqBasico = true;
                          CalculosEoqBasico[0] = calcularQ.calcularQ(
                              double.parse(demandaController.text),
                              double.parse(costoMantenerController.text),
                              double.parse(
                                costoPedidoController.text,
                              ));
                          CalculosEoqBasico[1] = calcularQ.calcularT(
                              double.parse(demandaController.text),
                              CalculosEoqBasico[0]);

                          CalculosEoqBasico[2] =
                              calcularQ.calcularN(CalculosEoqBasico[1]);

                          CalculosEoqBasico[3] = calcularQ.calcularCostoTotal(
                              double.parse(
                                costoPedidoController.text,
                              ),
                              double.parse(
                                costoPorUnidadController.text,
                              ),
                              CalculosEoqBasico[0],
                              double.parse(
                                costoMantenerController.text,
                              ),
                              double.parse(
                                demandaController.text,
                              ));
                        }

                        if (demandaController != null &&
                            costoMantenerController != null &&
                            costoPedidoController != null &&
                            costoPorUnidadController != null &&
                            costoFaltanteControler != null) {
                          CalculoEoqFaltantes = true;
                          CalculosEoqFaltantes[0] = calcularFaltantes.calcularQ(
                            double.parse(demandaController.text),
                            double.parse(costoMantenerController.text),
                            double.parse(costoPedidoController.text),
                            double.parse(costoFaltanteControler.text),
                          );
                          CalculosEoqFaltantes[1] = calcularFaltantes.calcularS(
                            double.parse(demandaController.text),
                            double.parse(costoMantenerController.text),
                            double.parse(costoPedidoController.text),
                            double.parse(costoFaltanteControler.text),
                          );

                          CalculosEoqFaltantes[2] = calcularFaltantes.calcularT(
                              double.parse(demandaController.text),
                              CalculosEoqFaltantes[0]);

                          CalculosEoqFaltantes[3] = calcularFaltantes
                              .calcularN(CalculosEoqFaltantes[2]);

                          CalculosEoqFaltantes[4] =
                              calcularFaltantes.calcularFaltanteMaximo(
                                  CalculosEoqFaltantes[0],
                                  CalculosEoqFaltantes[1]);

                          CalculosEoqFaltantes[5] =
                              calcularFaltantes.calcularCostoTotal(
                            double.parse(costoPedidoController.text),
                            double.parse(costoPorUnidadController.text),
                            CalculosEoqFaltantes[0],
                            double.parse(costoMantenerController.text),
                            double.parse(demandaController.text),
                            CalculosEoqFaltantes[1],
                            double.parse(costoFaltanteControler.text),
                          );
                        }
                        print(CalculosEoqBasico);
                      });
                    },
                    child: Text('Calcular'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
