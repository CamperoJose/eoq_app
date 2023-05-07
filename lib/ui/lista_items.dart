import 'package:flutter/material.dart';

import '../Database/database_helper.dart';
import '../Modelos/eoq_basico_resultado.dart';
import '../Modelos/eoq_descuentos_resultado.dart';
import '../Modelos/eoq_faltantes_resultado.dart';

class EoqListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseProvider = DatabaseProvider();
    return Scaffold(
      appBar: AppBar(
        title: Text('EOQ List'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper01.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            databaseProvider.retrieveEoqBasicos(),
            databaseProvider.retrieveEoqDescuentos(),
            databaseProvider.retrieveEoqFaltantes(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<EoqBasicoResultado> basicos =
                  snapshot.data![0] as List<EoqBasicoResultado>;
              List<EoqDescuentosResultado> descuentos =
                  snapshot.data![1] as List<EoqDescuentosResultado>;
              List<EoqFaltantesResultado> faltantes =
                  snapshot.data![2] as List<EoqFaltantesResultado>;
              // Aquí puedes crear tus widgets para mostrar los datos

              return ListView.builder(
                itemCount:
                    basicos.length + descuentos.length + faltantes.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < basicos.length) {
                    // Mostrar datos del EOQ básico
                    EoqBasicoResultado eoqBasico = basicos[index];
                    return _buildEoqItem(
                      'EOQ básico',
                      eoqBasico.productoId,
                      eoqBasico.cantidadOptima,
                    );
                  } else if (index < basicos.length + descuentos.length) {
                    // Mostrar datos del EOQ con descuentos
                    EoqDescuentosResultado eoqDescuentos =
                        descuentos[index - basicos.length];
                    return _buildEoqItem(
                      'EOQ con descuentos',
                      eoqDescuentos.productoId,
                      eoqDescuentos.cantidadOptima,
                    );
                  } else {
                    // Mostrar datos del EOQ con faltantes
                    EoqFaltantesResultado eoqFaltantes =
                        faltantes[index - basicos.length - descuentos.length];
                    return _buildEoqItem(
                      'EOQ con faltantes',
                      eoqFaltantes.productoId,
                      eoqFaltantes.cantidadOptima,
                    );
                  }
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildEoqItem(String title, int productId, double cantidadOptima) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: Colors.orange,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          '$title - Producto $productId',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Cantidad óptima: $cantidadOptima'),
      ),
    );
  }
}
