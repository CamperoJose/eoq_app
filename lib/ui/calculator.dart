import 'dart:math';

import 'package:eoq_app/Database/database_helper.dart';
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
import '../Modelos/eoq_basico_resultado.dart';
import '../Modelos/eoq_descuentos_resultado.dart';
import '../Modelos/eoq_faltantes.dart';
import '../Modelos/eoq_faltantes_resultado.dart';
import '../Modelos/producto.dart';
import '../Modelos/proveedor.dart';
import '../UI/lista_items.dart';

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
    final double calculoQ = eoq_descuentos_cubit.state.calculoQ;
    final cantidadOrdenar = eoq_descuentos_cubit.state.cantidadOrdenar;
    final costoPorOrdenar = eoq_descuentos_cubit.state.costoPorOrdenar;
    final costoAnualPedido = eoq_descuentos_cubit.state.costoAnualPedido;
    final costoAnualMantenimiento =
        eoq_descuentos_cubit.state.costoAnualMantenimiento;
    final costoTotal = eoq_descuentos_cubit.state.costoTotal;

    Future<void> _showConfirmationDialog(BuildContext context) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Datos guardados'),
            content: const Text('Los datos se guardaron correctamente.'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> guardarDatos() async {
      if (nombreController.text.isEmpty ||
          celularController.text.isEmpty ||
          telefonoController.text.isEmpty ||
          correoController.text.isEmpty ||
          productoNombreController.text.isEmpty ||
          descripcionController.text.isEmpty ||
          precioVentaController.text.isEmpty) {
        // Si algún campo está vacío, mostrar un diálogo de alerta
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Campos vacíos'),
              content: const Text('Por favor, llena todos los campos.'),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Si todos los campos están llenos, guardar los datos en la base de datos.

        // Primero, crea una instancia de DatabaseHelper
        DatabaseProvider dbHelper = DatabaseProvider();

        // Crear instancia de Proveedor y agregar a la base de datos
        Proveedor proveedor = Proveedor(
          id: null,
          nombre: nombreController.text,
          celular: celularController.text,
          telefono: telefonoController.text,
          correo: correoController.text,
        );
        int proveedorId = await dbHelper.insertProveedor(proveedor);

        // Crear instancia de Producto y agregar a la base de datos
        Producto producto = Producto(
          id: null,
          proveedorId: proveedorId,
          nombre: productoNombreController.text,
          descripcion: descripcionController.text,
          precioVenta: double.parse(precioVentaController.text),
        );
        int productoId = await dbHelper.insertProducto(producto);

        // Determinar el EOQ con el costo total mínimo
        double minCost = min(
            CalculosEoqBasico[3],
            min(CalculosEoqFaltantes[5],
                eoq_descuentos_cubit.state.costoTotal ?? double.infinity));

        // Crear instancia de EOQ correspondiente y agregar a la base de datos
        if (minCost == CalculosEoqBasico[3]) {
          EoqBasicoResultado eoqBasico = EoqBasicoResultado(
            id: null,
            productoId: productoId,
            cantidadOptima: CalculosEoqBasico[0],
            tiempoCiclo: CalculosEoqBasico[1],
            numeroCiclo: CalculosEoqBasico[2],
            costoTotal: CalculosEoqBasico[3],
          );
          await dbHelper.insertEoqBasico(eoqBasico);
          // ignore: use_build_context_synchronously
          await _showConfirmationDialog(context);
        } else if (minCost == CalculosEoqFaltantes[5]) {
          EoqFaltantesResultado eoqFaltante = EoqFaltantesResultado(
            id: null,
            productoId: productoId,
            cantidadOptima: CalculosEoqFaltantes[0],
            nivelMaximo: CalculosEoqFaltantes[1],
            tiempoCiclo: CalculosEoqFaltantes[2],
            numeroCiclo: CalculosEoqFaltantes[3],
            faltante: CalculosEoqFaltantes[4],
            costoTotal: CalculosEoqFaltantes[5],
          );
          await dbHelper.insertEoqFaltante(eoqFaltante);
          // ignore: use_build_context_synchronously
          await _showConfirmationDialog(context);
        } else if (minCost == eoq_descuentos_cubit.state.costoTotal) {
          EoqDescuentosResultado eoqDescuento = EoqDescuentosResultado(
            id: null,
            productoId: productoId,
            cantidadOptima: calculoQ,
            cantidadOrdenar: cantidadOrdenar,
            costoMantenimiento: costoAnualMantenimiento,
            costoPedido: costoAnualPedido,
            costoPorOrdenar: costoPorOrdenar,
            costoTotal: costoTotal,
          );
          await dbHelper.insertEoqDescuento(eoqDescuento);
          // ignore: use_build_context_synchronously
          await _showConfirmationDialog(context);
        }
      }
    }

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
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16,
              ),
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
                      BootstrapRow(
                        children: [
                          BootstrapCol(
                            sizes: 'col-md-4 col-sm-12',
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    Column(
                                      children: [
                                        !CalculoEoqBasico
                                            ? const Text(
                                                "Sin Datos Suficientes")
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Cantidad Optima",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqBasico[0]} unidades \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Tiempo de Ciclos",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqBasico[1]} meses \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Número de Ciclos",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqBasico[2]} pedidos \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Costo Total",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqBasico[3]} \$ \n"),
                                                ],
                                              ),
                                      ],
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    Column(
                                      children: [
                                        !CalculoEoqFaltantes
                                            ? const Text(
                                                "Sin Datos Suficientes")
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Cantidad Optima",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqFaltantes[0]} unidades \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Cantidad Ordenar",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqFaltantes[1]} unidades \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Tiempo de Ciclos",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqFaltantes[2]} meses \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Número de Ciclos",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqFaltantes[3]} pedidos \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Faltantes Máximos",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqFaltantes[4]} unidades \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Costo Total",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "${CalculosEoqFaltantes[5]} \$ \n"),
                                                ],
                                              ),
                                      ],
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            costoAnualMantenimiento == null ||
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
                                              backgroundColor: Colors.orange,
                                            ),
                                            child: const Text(
                                                "Agregar Cantidades"),
                                          )
                                        : Column(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Cantidad Optima",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text("$calculoQ unidades \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Cantidad Ordenar",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "$cantidadOrdenar unidades \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Costo Por Ordenar",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "$costoPorOrdenar \$ \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Costo Anual Pedido",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "$costoAnualPedido \$ \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Costo Mantenimiento",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text(
                                                      "$costoAnualMantenimiento \$ \n"),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    color: Colors.orange,
                                                    child: const Text(
                                                      "Costo Total",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Text("$costoTotal \$ \n"),
                                                ],
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
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: (CalculosEoqBasico[3] != 0 &&
                                CalculosEoqFaltantes[5] != 0)
                            ? StatisticsGraph(
                                calculosEoqBasico: CalculosEoqBasico,
                                calculosEoqFaltantes: CalculosEoqFaltantes,
                                costoTotal: costoTotal,
                              )
                            : Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                    child: Text('Estadísticas',
                                        style: TextStyle(color: Colors.white))),
                              ),
                      ),
                      BootstrapCol(
                        sizes: 'col-md-4 col-sm-12',
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                guardarDatos();
                              },
                              child: const Text('Guardar la mejor solución'),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EoqListScreen()));
                                            
                              },
                              child: const Text('Ver soluciones guardadas'),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
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
