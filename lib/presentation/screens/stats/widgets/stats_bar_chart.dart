import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/repositories/quiz_attempt_repository.dart';

/// Gráfico de barras horizontales: acierto % por tipo de pregunta
class StatsBarChart extends StatelessWidget {
  final Map<String, QuestionStats> statsByType;

  const StatsBarChart({super.key, required this.statsByType});

  @override
  Widget build(BuildContext context) {
    // Ordenar por success rate descendente
    final sorted = statsByType.entries.toList()
        ..sort((a, b) => b.value.successRate.compareTo(a.value.successRate));

    // Mapear a BarChartGroupData
    final barGroups = List.generate(
      sorted.length,
      (index) {
        final value = sorted[index];
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: value.value.successRate * 100,
              color: _getColorForRate(value.value.successRate),
              width: 24,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              rodStackItems: [],
            ),
          ],
        );
      },
    );

    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 32),
      child: BarChart(
        BarChartData(
          maxY: 100,
          minY: 0,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  '${value.toInt()}%',
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sorted.length) return const SizedBox();
                  return Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      sorted[index].key,
                      style: GoogleFonts.lexend(
                        fontSize: 9,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Color _getColorForRate(double rate) {
    if (rate >= 0.75) return AppColors.success;
    if (rate >= 0.50) return AppColors.yellow500;
    return AppColors.error;
  }
}
