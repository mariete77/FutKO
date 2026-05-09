import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

/// Rules screen — how to play, scoring system, and FAQ.
class RulesScreen extends ConsumerStatefulWidget {
  const RulesScreen({super.key});

  @override
  ConsumerState<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends ConsumerState<RulesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      body: Column(
        children: [
          // ── Top Bar ────────────────────────────────────
          _buildTopBar(),

          // ── Tab Bar ────────────────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.onPrimary,
              unselectedLabelColor: AppColors.onSurfaceVariant,
              labelStyle: GoogleFonts.workSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.workSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
              tabs: const [
                Tab(text: 'Cómo jugar'),
                Tab(text: 'Puntuación'),
                Tab(text: 'FAQ'),
              ],
            ),
          ),

          // ── Tab Content ────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHowToPlayTab(),
                _buildScoringTab(),
                _buildFAQTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(color: AppColors.background),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
              child: IconButton(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Cómo jugar',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const Spacer(),
            const Icon(Icons.stadium, color: AppColors.tertiary, size: 28),
          ],
        ),
      ),
    );
  }

  // ── How To Play Tab ──────────────────────────────────

  Widget _buildHowToPlayTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FutKO Battle',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'El trivia de fútbol definitivo',
                            style: GoogleFonts.workSans(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: 32),

          // Steps
          Text(
            'Pasos para jugar',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          _buildStepCard(
            number: 1,
            title: 'Elige tu modo',
            description: 'Partida rápida, Ranked o Entrenamiento. Cada modo tiene sus reglas y recompensas.',
            icon: Icons.videogame_asset,
            delay: 100,
          ),
          _buildStepCard(
            number: 2,
            title: 'Responde preguntas',
            description: 'Tendrás 10 segundos por pregunta. ¡Sé rápido pero preciso! Las preguntas son sobre equipos, jugadores y estadios.',
            icon: Icons.timer,
            delay: 200,
          ),
          _buildStepCard(
            number: 3,
            title: 'Gana puntos',
            description: 'Cada respuesta correcta suma puntos. Las respuestas rápidas dan bonus de velocidad.',
            icon: Icons.add_circle,
            delay: 300,
          ),
          _buildStepCard(
            number: 4,
            title: 'Sube de rango',
            description: 'Acumula ELO para subir de rango: Bronce → Plata → Oro → Platino → Diamante.',
            icon: Icons.emoji_events,
            delay: 400,
          ),

          const SizedBox(height: 32),

          // Game Modes
          Text(
            'Modos de juego',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          _buildGameModeCard(
            title: 'Partida Rápida',
            subtitle: 'Partida casual',
            description: 'Juega sin presión. Ideal para practicar y divertirte. No afecta tu ELO.',
            color: AppColors.primary,
            icon: Icons.flash_on,
          ),
          const SizedBox(height: 12),
          _buildGameModeCard(
            title: 'Ranked',
            subtitle: 'Competitivo',
            description: 'Enfréntate a jugadores de tu nivel. Gana ELO y sube en la clasificación.',
            color: AppColors.tertiary,
            icon: Icons.emoji_events,
          ),
          const SizedBox(height: 12),
          _buildGameModeCard(
            title: 'Entrenamiento',
            subtitle: 'Solo contra el tiempo',
            description: 'Practica sin límite de tiempo. Perfecto para aprender las preguntas.',
            color: AppColors.secondaryFixed,
            icon: Icons.fitness_center,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required int number,
    required String title,
    required String description,
    required IconData icon,
    required int delay,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms);
  }

  Widget _buildGameModeCard({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subtitle,
                        style: GoogleFonts.workSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.workSans(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Scoring Tab ──────────────────────────────────────

  Widget _buildScoringTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Points breakdown
          Text(
            'Sistema de puntuación',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          _buildScoreCard(
            title: 'Respuesta correcta',
            points: '+100',
            description: 'Base por cada acierto',
            color: AppColors.primary,
            icon: Icons.check_circle,
          ),
          _buildScoreCard(
            title: 'Bonus de velocidad',
            points: '+50',
            description: 'Si respondes en < 3 segundos',
            color: Colors.orange,
            icon: Icons.bolt,
          ),
          _buildScoreCard(
            title: 'Racha de aciertos',
            points: '+25',
            description: 'Por cada respuesta consecutiva',
            color: AppColors.tertiary,
            icon: Icons.local_fire_department,
          ),
          _buildScoreCard(
            title: 'Victoria perfecta',
            points: '+500',
            description: 'Todas las respuestas correctas',
            color: AppColors.secondaryFixed,
            icon: Icons.star,
          ),

          const SizedBox(height: 32),

          // ELO ranks
          Text(
            'Rangos ELO',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          _buildRankRow('Diamante', '1800+ ELO', const Color(0xFF00BCD4), Icons.diamond),
          _buildRankRow('Platino', '1600-1799 ELO', const Color(0xFF9C27B0), Icons.workspace_premium),
          _buildRankRow('Oro', '1400-1599 ELO', const Color(0xFFFFD700), Icons.emoji_events),
          _buildRankRow('Plata', '1200-1399 ELO', const Color(0xFFC0C0C0), Icons.military_tech),
          _buildRankRow('Bronce', '< 1200 ELO', const Color(0xFFCD7F32), Icons.shield),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildScoreCard({
    required String title,
    required String points,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              points,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankRow(String rank, String elo, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              rank,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Text(
            elo,
            style: GoogleFonts.workSans(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // ── FAQ Tab ──────────────────────────────────────────

  Widget _buildFAQTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preguntas frecuentes',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          _buildFAQItem(
            question: '¿Cómo se calcula el ELO?',
            answer: 'Tu ELO cambia según el resultado de las partidas ranked. Ganas más ELO al vencer a jugadores con mayor ranking que tú.',
          ),
          _buildFAQItem(
            question: '¿Cuántas partidas puedo jugar al día?',
            answer: 'Las partidas ranked están limitadas por día para mantener la competencia saludable. Las partidas rápidas y entrenamiento son ilimitadas.',
          ),
          _buildFAQItem(
            question: '¿Qué son los logros?',
            answer: 'Los logros son recompensas por alcanzar hitos específicos: rachas de victorias, respuestas correctas, etc.',
          ),
          _buildFAQItem(
            question: '¿Puedo jugar con amigos?',
            answer: 'Sí, puedes agregar amigos y ver su posición en el leaderboard. Pronto habrá partidas privadas.',
          ),
          _buildFAQItem(
            question: '¿Qué pasa si abandono una partida?',
            answer: 'Abandonar una partida ranked resulta en una derrota automática y penalización de ELO.',
          ),
          _buildFAQItem(
            question: '¿Cómo reporto un error?',
            answer: 'Puedes contactarnos desde Ajustes > Soporte. Valoramos tu feedback para mejorar el juego.',
          ),

          const SizedBox(height: 32),

          // Contact card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.tertiary.withOpacity(0.2),
                  AppColors.tertiary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(Icons.support_agent, size: 48, color: AppColors.tertiary),
                const SizedBox(height: 16),
                Text(
                  '¿Necesitas más ayuda?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nuestro equipo de soporte está listo para ayudarte con cualquier duda.',
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('Contactar soporte'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.onSurfaceVariant,
        title: Text(
          question,
          style: GoogleFonts.workSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        children: [
          Text(
            answer,
            style: GoogleFonts.workSans(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
