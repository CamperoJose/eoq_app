import 'package:flutter/material.dart';

class StatisticsGraph extends StatelessWidget {
  const StatisticsGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Text('Gráficas estadísticas aquí')),
    );
  }
}
