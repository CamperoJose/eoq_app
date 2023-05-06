import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import '../Componentes/chat_gpt.dart';
import '../Componentes/statistics.dart';
import '../Componentes/text_field2.dart';
import '../Modelos/eoq_basico.dart';

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
  TextEditingController interesController = TextEditingController();

  List<double> CalculosEoqBasico = [0, 0, 0, 0];

  bool CalculoEoqBasico = false;
  final bool CalculoEoqFaltantes = false;
  final bool CalculoEoqDescuentos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wallpaper01.png'),
              fit: BoxFit.cover, // o BoxFit.contain
            ),
          ),
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 16, bottom: 500),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
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
                        // StatisticsGraph
                        Column(
                          children: [
                            Text(
                              "Cálculos",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "EOQ BASICO",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      !CalculoEoqBasico
                                          ? "Sin Datos Suficientes"
                                          : "Q: ${CalculosEoqBasico[0]} unidades\nT: ${CalculosEoqBasico[1]} meses\nN: ${CalculosEoqBasico[2]} pedidos\nCT: ${CalculosEoqBasico[3]} \$",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "EOQ FALTANTES",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "EOQ DESCUENTOS POR CANTIDAD",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: BootstrapContainer(
                            fluid: true,
                            children: [
                              BootstrapRow(
                                children: [
                                  BootstrapCol(
                                    sizes: 'col-12 col-md-6',
                                    child: ChatGPTMessage(
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
            ),
          )),
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
                    controller: interesController,
                    labelText: 'I: Interés ...',
                    prefixIcon: Icons.assessment,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      EoqBasico calcularQ = EoqBasico();
                      setState(() {
                        if (demandaController != null &&
                            costoMantenerController != null &&
                            costoPedidoController != null) {
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
