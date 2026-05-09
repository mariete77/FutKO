import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

/// Profile screen — user profile with stats, edit name, and settings shortcuts.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditingName = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final userAsync = ref.watch(userNotifierProvider);

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    // Use currentUser as primary, but fall back to userAsync if available
    final displayUser = userAsync.valueOrNull ?? currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.emerald950,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.emerald950,
                    ],
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: IconButton(
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.settings, color: AppColors.onSurface),
                ),
              ),
            ],
          ),

          // ── Profile Header ──────────────────────────────
          SliverToBoxAdapter(
            child: _buildProfileHeader(displayUser),
          ),

          // ── Stats Cards ─────────────────────────────────
          SliverToBoxAdapter(
            child: _buildStatsSection(displayUser),
          ),

          // ── Performance Stats ───────────────────────────
          SliverToBoxAdapter(
            child: userAsync.when(
              loading: () => _buildStatsLoading(),
              error: (_, __) => _buildPerformanceStats(displayUser.stats),
              data: (user) => _buildPerformanceStats(user?.stats ?? displayUser.stats),
            ),
          ),

          // ── Account Info ────────────────────────────────
          SliverToBoxAdapter(
            child: _buildAccountInfo(displayUser),
          ),

          // ── Bottom padding ──────────────────────────────
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  // ── Profile Header ───────────────────────────────────

  Widget _buildProfileHeader(User user) {
    return Transform.translate(
      offset: const Offset(0, -50),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Avatar with rank badge
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondaryFixed,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryFixed.withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage:
                        user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: user.photoUrl == null
                        ? Text(
                            user.displayName.isNotEmpty
                                ? user.displayName[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          )
                        : null,
                  ),
                ),
                // Rank badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.secondaryFixed,
                        AppColors.secondaryFixedDim,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.surfaceContainerLow,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    user.rank,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSecondaryFixedVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name with edit
            if (_isEditingName)
              _buildNameEditor()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.displayName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _nameController.text = user.displayName;
                        _isEditingName = true;
                      });
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 8),

            // Email
            if (user.email != null)
              Text(
                user.email!,
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),

            const SizedBox(height: 16),

            // ELO Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: AppColors.secondaryFixed,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.elo}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                          height: 1,
                        ),
                      ),
                      Text(
                        'ELO Rating',
                        style: GoogleFonts.workSans(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildNameEditor() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextField(
            controller: _nameController,
            autofocus: true,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Tu nombre',
              hintStyle: GoogleFonts.plusJakartaSans(
                color: AppColors.onSurfaceVariant.withOpacity(0.5),
              ),
              filled: true,
              fillColor: AppColors.surfaceContainerHighest.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            // TODO: Implement name update
            setState(() {
              _isEditingName = false;
            });
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 20, color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isEditingName = false;
            });
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 20, color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  // ── Stats Section ────────────────────────────────────

  Widget _buildStatsSection(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.local_fire_department,
              value: '${user.stats.currentWinStreak}',
              label: 'Racha actual',
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.trending_up,
              value: '${(user.winRate * 100).toInt()}%',
              label: 'Win Rate',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.military_tech,
              value: '${user.stats.bestWinStreak}',
              label: 'Mejor racha',
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.workSans(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Performance Stats ────────────────────────────────

  Widget _buildStatsLoading() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsError() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Error al cargar estadísticas',
                style: GoogleFonts.workSans(color: AppColors.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceStats(UserStats stats) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rendimiento',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildPerformanceRow(
                  label: 'Partidas totales',
                  value: '${stats.totalGames}',
                  icon: Icons.sports_soccer,
                ),
                const Divider(height: 24),
                _buildPerformanceRow(
                  label: 'Victorias',
                  value: '${stats.wins}',
                  icon: Icons.check_circle,
                  color: AppColors.primary,
                ),
                const Divider(height: 24),
                _buildPerformanceRow(
                  label: 'Derrotas',
                  value: '${stats.losses}',
                  icon: Icons.cancel,
                  color: AppColors.error,
                ),
                const Divider(height: 24),
                _buildPerformanceRow(
                  label: 'Empates',
                  value: '${stats.draws}',
                  icon: Icons.remove_circle,
                  color: AppColors.onSurfaceVariant,
                ),
                const Divider(height: 24),
                _buildPerformanceRow(
                  label: 'Respuestas correctas',
                  value: '${stats.totalCorrectAnswers}',
                  icon: Icons.psychology,
                  color: AppColors.tertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildPerformanceRow({
    required String label,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (color ?? AppColors.onSurfaceVariant).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color ?? AppColors.onSurfaceVariant),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.workSans(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  // ── Account Info ─────────────────────────────────────

  Widget _buildAccountInfo(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cuenta',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                _buildAccountTile(
                  icon: Icons.calendar_today,
                  title: 'Miembro desde',
                  subtitle: DateFormat('dd MMM yyyy').format(user.createdAt),
                ),
                const Divider(height: 1, indent: 56),
                _buildAccountTile(
                  icon: Icons.verified,
                  title: 'Suscripción',
                  subtitle: user.isPremium ? 'Premium' : 'Gratuita',
                  trailing: user.isPremium
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'PRO',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.tertiary,
                            ),
                          ),
                        )
                      : null,
                ),
                const Divider(height: 1, indent: 56),
                _buildAccountTile(
                  icon: Icons.history,
                  title: 'Historial',
                  subtitle: 'Ver todas tus partidas',
                  onTap: () => context.go('/history'),
                  showArrow: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Sign out button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: Text(
                'Cerrar sesión',
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }

  Widget _buildAccountTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showArrow = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: GoogleFonts.workSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.workSans(
          fontSize: 12,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: trailing ??
          (showArrow
              ? Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.onSurfaceVariant)
              : null),
    );
  }
}
