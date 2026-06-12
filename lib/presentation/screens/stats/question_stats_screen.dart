import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/question_stats_provider.dart';
import 'widgets/stats_bar_chart.dart';
import 'widgets/question_rank_card.dart';

/// Pantalla de estadísticas de preguntas: más falladas, más acertadas, por tipo
class QuestionStatsScreen extends ConsumerStatefulWidget {
  const QuestionStatsScreen({super.key});

  @override
  ConsumerState<QuestionStatsScreen> createState() => _QuestionStatsScreenState();
}

class _QuestionStatsScreenState extends ConsumerState<QuestionStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.emerald950,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Estadísticas de Preguntas',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Por Pregunta'),
            Tab(text: 'Por Tipo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildByQuestionTab(),
          _buildByTypeTab(),
        ],
      ),
    );
  }

  Widget _buildByQuestionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top falladas
          _buildSection(
            title: 'Preguntas Más Falladas',
            icon: Icons.trending_down,
            iconColor: AppColors.error,
            child: ref.watch(mostFailedQuestionsProvider).when(
              data: (questions) {
                if (questions.isEmpty) {
                  return _buildEmptyState('Sin datos de fallos aún');
                }
                return Column(
                  children: List.generate(
                    questions.length,
                    (i) => QuestionRankCard(
                      stats: questions[i],
                      rank: i + 1,
                      isTopTen: true,
                    ),
                  ),
                );
              },
              loading: () => _buildLoader(),
              error: (e, st) => _buildError(e.toString()),
            ),
          ),
          const SizedBox(height: 32),

          // Top acertadas
          _buildSection(
            title: 'Preguntas Más Fáciles',
            icon: Icons.trending_up,
            iconColor: AppColors.success,
            child: ref.watch(easiestQuestionsProvider).when(
              data: (questions) {
                if (questions.isEmpty) {
                  return _buildEmptyState('Sin datos de aciertos aún');
                }
                return Column(
                  children: List.generate(
                    questions.length,
                    (i) => QuestionRankCard(
                      stats: questions[i],
                      rank: i + 1,
                      isTopTen: false,
                    ),
                  ),
                );
              },
              loading: () => _buildLoader(),
              error: (e, st) => _buildError(e.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildByTypeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ref.watch(statsByTypeProvider).when(
            data: (statsByType) {
              if (statsByType.isEmpty) {
                return _buildEmptyState('Sin datos de tipos aún');
              }

              // Tabla resumen
              return Column(
                children: [
                  _buildSection(
                    title: 'Acierto % por Tipo',
                    icon: Icons.bar_chart,
                    child: StatsBarChart(statsByType: statsByType),
                  ),
                  const SizedBox(height: 32),

                  _buildSection(
                    title: 'Resumen Detallado',
                    icon: Icons.list,
                    child: _buildTypeSummaryTable(statsByType),
                  ),
                ],
              );
            },
            loading: () => _buildLoader(),
            error: (e, st) => _buildError(e.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSummaryTable(Map<String, dynamic> statsByType) {
    final types = statsByType.entries.toList()
        ..sort((a, b) {
          final aRate = (a.value as dynamic).successRate as double;
          final bRate = (b.value as dynamic).successRate as double;
          return bRate.compareTo(aRate);
        });

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: types.map((entry) {
          final type = entry.key;
          final stats = entry.value;
          final rate = (stats.successRate * 100).toStringAsFixed(1);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        type,
                        style: GoogleFonts.lexend(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      '$rate%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: stats.successRate >= 0.6
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${stats.totalAttempts}',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (entry.key != types.last.key)
                Divider(
                  height: 0,
                  color: Colors.white.withOpacity(0.06),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    Color? iconColor,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildLoader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Cargando estadísticas...',
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: AppColors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Error: $message',
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
