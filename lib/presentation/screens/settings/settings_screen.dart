import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/audio_settings_provider.dart';
import '../home/widgets/subscription_modal.dart';
import '../../../core/theme/app_colors.dart';

/// Pantalla de ajustes: cuenta, suscripción, preferencias y sesión.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(userNotifierProvider).valueOrNull ?? ref.watch(currentUserProvider);
    final isPremium = user?.isPremium ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.emerald950,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(
          'Ajustes',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // ── Cuenta ──────────────────────────────────────────
          _sectionLabel('Cuenta'),
          _card(
            child: Column(
              children: [
                _infoRow(Icons.person_outline, 'Nombre',
                    user?.displayName ?? '—'),
                if (user?.email != null) ...[
                  const Divider(height: 1, color: Colors.white10),
                  _infoRow(Icons.email_outlined, 'Email', user!.email!),
                ],
                const Divider(height: 1, color: Colors.white10),
                _infoRow(
                  Icons.workspace_premium_outlined,
                  'Plan',
                  isPremium ? 'Premium' : 'Gratis',
                  valueColor: isPremium ? AppColors.yellow500 : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Suscripción ─────────────────────────────────────
          _sectionLabel('Suscripción'),
          _card(
            child: _tile(
              icon: Icons.star_outline,
              iconColor: AppColors.yellow500,
              title: isPremium ? 'Gestionar Premium' : 'Hazte Premium',
              subtitle: isPremium
                  ? 'Tu suscripción está activa'
                  : 'Partidas ilimitadas y sin anuncios',
              onTap: () => SubscriptionModal.show(context),
            ),
          ),
          const SizedBox(height: 24),

          // ── Preferencias ────────────────────────────────────
          _sectionLabel('Preferencias'),
          _card(
            child: Column(
              children: [
                // Audio SFX toggle
                _switchRow(
                  ref,
                  icon: Icons.volume_up_outlined,
                  title: 'Efectos de Sonido',
                  provider: audioSfxEnabledProvider,
                ),
                const Divider(height: 1, color: Colors.white10),
                // Audio Music toggle
                _switchRow(
                  ref,
                  icon: Icons.music_note_outlined,
                  title: 'Música',
                  provider: audioMusicEnabledProvider,
                ),
                const Divider(height: 1, color: Colors.white10),
                // Language (placeholder)
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Más idiomas próximamente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: _infoRow(Icons.language_outlined, 'Idioma', 'Español'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Sesión ──────────────────────────────────────────
          _sectionLabel('Sesión'),
          _card(
            child: _tile(
              icon: Icons.logout,
              iconColor: AppColors.error,
              title: 'Cerrar sesión',
              titleColor: AppColors.error,
              onTap: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) context.go('/login');
              },
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: Text(
              'FutKO Battle · v1.0.0',
              style: GoogleFonts.lexend(
                fontSize: 12,
                color: AppColors.onSurfaceVariant.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.lexend(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 3,
          ),
        ),
      );

  Widget _card({required Widget child}) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );

  Widget _infoRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 14),
          Text(
            label,
            style: GoogleFonts.lexend(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _switchRow(
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required StateNotifierProvider<StateNotifier<bool>, bool> provider,
  }) {
    final value = ref.watch(provider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 14),
          Text(
            title,
            style: GoogleFonts.lexend(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: (newValue) {
                ref.read(provider.notifier).set(newValue);
              },
              activeColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
