import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsGraph extends StatelessWidget {
  final List<double> calculosEoqBasico;
  final List<double> calculosEoqFaltantes;
  final double? costoTotal;

  const StatisticsGraph({
    Key? key,
    required this.calculosEoqBasico,
    required this.calculosEoqFaltantes,
    required this.costoTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (calculosEoqBasico == null || calculosEoqFaltantes == null) {
      return const SizedBox.shrink();
    }

    List<PieChartSectionData> _pieChartSections() {
      final List<PieChartSectionData> sections = [];
      sections.add(PieChartSectionData(value: calculosEoqBasico[3], color: Colors.lightBlueAccent, title: 'EOQ básico', radius: 80));
      sections.add(PieChartSectionData(value: calculosEoqFaltantes[5], color: Colors.orangeAccent, title: 'EOQ faltantes', radius: 80));
      if (costoTotal != null) {
        sections.add(PieChartSectionData(value: costoTotal!, color: Colors.pinkAccent, title: 'EOQ descuentos', radius: 80));
      }
      return sections;
    }

    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 30,
            sections: _pieChartSections(),
            pieTouchData: PieTouchData(enabled: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
