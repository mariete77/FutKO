import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/theme/app_colors.dart';

/// Settings screen for audio, notifications, and app preferences
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _sfxVolume = 1.0;
  double _musicVolume = 0.5;
  bool _notificationsEnabled = true;
  bool _hapticEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _soundEnabled = audioService.isSoundEnabled;
      _musicEnabled = audioService.isMusicEnabled;
      _sfxVolume = audioService.sfxVolume;
      _musicVolume = audioService.musicVolume;
    });
  }

  Future<void> _toggleSound(bool value) async {
    setState(() => _soundEnabled = value);
    audioService.toggleSound(value);
    if (value) {
      await audioService.playButtonClick();
    }
  }

  Future<void> _toggleMusic(bool value) async {
    setState(() => _musicEnabled = value);
    await audioService.toggleMusic(value);
  }

  Future<void> _setSfxVolume(double value) async {
    setState(() => _sfxVolume = value);
    await audioService.setSfxVolume(value);
  }

  Future<void> _setMusicVolume(double value) async {
    setState(() => _musicVolume = value);
    await audioService.setMusicVolume(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    const Color(0xFF1a2e1d),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Settings list
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Audio Section
                        _buildSectionTitle('AUDIO'),
                        const SizedBox(height: 12),
                        _buildAudioSettings(),

                        const SizedBox(height: 24),

                        // Notifications Section
                        _buildSectionTitle('NOTIFICACIONES'),
                        const SizedBox(height: 12),
                        _buildNotificationSettings(),

                        const SizedBox(height: 24),

                        // Gameplay Section
                        _buildSectionTitle('GAMEPLAY'),
                        const SizedBox(height: 12),
                        _buildGameplaySettings(),

                        const SizedBox(height: 24),

                        // About Section
                        _buildSectionTitle('ACERCA DE'),
                        const SizedBox(height: 12),
                        _buildAboutSettings(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.emerald950.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            'AJUSTES',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.lexend(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildAudioSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          // Sound Effects Toggle
          _buildToggleTile(
            icon: Icons.volume_up,
            title: 'Efectos de Sonido',
            subtitle: 'Sonidos de respuestas y logros',
            value: _soundEnabled,
            onChanged: _toggleSound,
          ),
          const Divider(height: 1, indent: 56),

          // SFX Volume Slider
          AnimatedOpacity(
            opacity: _soundEnabled ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 200),
            child: _buildSliderTile(
              icon: Icons.tune,
              title: 'Volumen de Efectos',
              value: _sfxVolume,
              onChanged: _soundEnabled ? _setSfxVolume : null,
            ),
          ),
          const Divider(height: 1, indent: 56),

          // Music Toggle
          _buildToggleTile(
            icon: Icons.music_note,
            title: 'Música de Fondo',
            subtitle: 'Música durante el juego',
            value: _musicEnabled,
            onChanged: _toggleMusic,
          ),
          const Divider(height: 1, indent: 56),

          // Music Volume Slider
          AnimatedOpacity(
            opacity: _musicEnabled ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 200),
            child: _buildSliderTile(
              icon: Icons.tune,
              title: 'Volumen de Música',
              value: _musicVolume,
              onChanged: _musicEnabled ? _setMusicVolume : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _buildToggleTile(
            icon: Icons.notifications,
            title: 'Notificaciones Push',
            subtitle: 'Partidas y logros',
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildGameplaySettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _buildToggleTile(
            icon: Icons.vibration,
            title: 'Retroalimentación Háptica',
            subtitle: 'Vibración al responder',
            value: _hapticEnabled,
            onChanged: (value) => setState(() => _hapticEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.info,
            title: 'Versión',
            value: '1.0.0',
          ),
          const Divider(height: 1, indent: 56),
          _buildActionTile(
            icon: Icons.policy,
            title: 'Política de Privacidad',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _buildActionTile(
            icon: Icons.description,
            title: 'Términos de Uso',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.lexend(
          fontSize: 12,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.yellow500,
        activeTrackColor: AppColors.yellow500.withOpacity(0.3),
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required ValueChanged<double>? onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      subtitle: Slider(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.yellow500,
        inactiveColor: Colors.white.withOpacity(0.1),
        divisions: 10,
        label: '${(value * 100).round()}%',
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      trailing: Text(
        value,
        style: GoogleFonts.lexend(
          fontSize: 14,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.3),
      ),
      onTap: onTap,
    );
  }
}
