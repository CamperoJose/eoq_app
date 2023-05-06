import 'package:flutter/material.dart';
import '../Componentes/button1.dart';
import '../Componentes/text_field1.dart';
import '../Componentes/text_field2.dart';
import '../Modelos/eoq_basico.dart';

class CalculatorView extends StatelessWidget {
  final TextEditingController _d = TextEditingController();
  final TextEditingController _h = TextEditingController();
  final TextEditingController _k = TextEditingController();
  final TextEditingController _i = TextEditingController();

  CalculatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper01.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Calculadora de modelos EOQ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
                const SizedBox(height: 20),

                Text(
                    "Instrucciones: introducir los valores que se conoces. En caso de no conocer un valor, se puede dejar en blanco.",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        color: Colors.white)),

                const SizedBox(height: 20),

                TextInputForm(
                    controller: _d,
                    labelText: "D: demanda",
                    prefixIcon: Icons.production_quantity_limits_rounded),

                const SizedBox(height: 20),
                TextInputForm(
                    controller: _h,
                    labelText: "h: costo de mantener",
                    prefixIcon: Icons.attach_money_sharp),

                const SizedBox(height: 20),


                TextInputForm(
                    controller: _k,
                    labelText: "k: costo de realizar pedido",
                    prefixIcon: Icons.attach_money),

                const SizedBox(height: 20),

                TextInputForm(
                    controller: _i,
                    labelText: "i: interes ...",
                    prefixIcon: Icons.percent_outlined),

                const SizedBox(height: 20),

                CustomElevatedButton(
                  buttonText: "Calcular",
                  onPressed: () {
                    EoqBasico calcularQ = EoqBasico();

                    print("Cantidad óptima de pedido: ${calcularQ.calcularQ(double.parse(_d.text), double.parse(_h.text), double.parse(_k.text))}");
                    //convertir un string a int en dart:
                    //https://stackoverflow.com/questions/12649573/how-do-i-convert-a-string-into-an-integer-in-dart


                  },
                ),
                const SizedBox(
                    height: 20), // Añadir espacio entre botón y texto
              ],
            ),
          ),
        ),
      ),
    );
  }
}
