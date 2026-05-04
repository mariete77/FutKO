import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

/// Login screen — "PantallaLogin" mockup.
/// Stadium atmosphere with grass texture, glassmorphism card, gradient CTA.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isSignUp = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isSignUp) {
      await ref.read(authNotifierProvider.notifier).signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            _displayNameController.text.trim(),
          );
    } else {
      await ref.read(authNotifierProvider.notifier).signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.hasValue && next.value != null && mounted) {
        context.go('/home');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Background stadium atmosphere ───────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.8),
                  radius: 1.2,
                  colors: [
                    AppColors.yellow500.withOpacity(0.05),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // ── Grass texture ───────────────────────────────
          Positioned.fill(
            child: CustomPaint(
              painter: _LoginGrassPainter(),
            ),
          ),

          // ── Bottom glow ─────────────────────────────────
          Positioned(
            bottom: -100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 600,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(300),
                  color: AppColors.secondaryFixed.withOpacity(0.03),
                ),
              ),
            ),
          ),

          // ── Main scrollable content ─────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical -
                      64,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(),

                      // ── Brand Section ─────────────────
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emerald950,
                              border: Border.all(
                                color: AppColors.yellow500.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.yellow500.withOpacity(0.2),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.sports_soccer,
                              size: 48,
                              color: AppColors.yellow500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'FutKO',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: AppColors.secondaryFixed,
                              fontStyle: FontStyle.italic,
                              letterSpacing: -2,
                              shadows: [
                                Shadow(
                                  color: AppColors.yellow500.withOpacity(0.4),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'WHERE CHAMPIONS ENTER THE FIELD',
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant.withOpacity(0.8),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // ── Login Card (Pitch Container) ──
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.outlineVariant.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.yellow500.withOpacity(0.08),
                              blurRadius: 60,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: const ColorFilter.matrix([
                              1, 0, 0, 0, 0,
                              0, 1, 0, 0, 0,
                              0, 0, 1, 0, 0,
                              0, 0, 0, 0.8, 0,
                            ]),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Decorative line
                                    Container(
                                      width: 64,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryFixed.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Display Name (sign up only)
                                    if (_isSignUp) ...[
                                      _buildTextField(
                                        controller: _displayNameController,
                                        label: 'NOMBRE',
                                        icon: Icons.person_outline,
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Introduce tu nombre'
                                                : null,
                                      ),
                                      const SizedBox(height: 16),
                                    ],

                                    // Email
                                    _buildTextField(
                                      controller: _emailController,
                                      label: 'EMAIL ADDRESS',
                                      icon: Icons.alternate_email,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (v) {
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Introduce tu email';
                                        }
                                        if (!v.contains('@')) return 'Email no válido';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),

                                    // Password
                                    _buildTextField(
                                      controller: _passwordController,
                                      label: 'PASSWORD',
                                      icon: Icons.lock_outline,
                                      obscureText: _obscurePassword,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: AppColors.outline,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(
                                            () => _obscurePassword = !_obscurePassword),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'Introduce tu contraseña';
                                        }
                                        if (v.length < 6) return 'Mínimo 6 caracteres';
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 24),

                                    // ── Kick Off Button ──
                                    _buildKickOffButton(authState),
                                    const SizedBox(height: 20),

                                    // Toggle sign up / sign in
                                    TextButton(
                                      onPressed: authState.isLoading
                                          ? null
                                          : () => setState(() => _isSignUp = !_isSignUp),
                                      child: RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.lexend(
                                            fontSize: 13,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: _isSignUp
                                                  ? '¿Ya tienes cuenta? '
                                                  : 'New to the stadium? ',
                                            ),
                                            TextSpan(
                                              text: _isSignUp
                                                  ? 'Inicia sesión'
                                                  : 'CREATE SQUAD',
                                              style: TextStyle(
                                                color: AppColors.secondaryFixed,
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.underline,
                                                decorationColor: AppColors.secondaryFixed.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Social Buttons ────────────────
                      if (!authState.isLoading) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildSocialButton(
                                icon: Icons.g_mobiledata,
                                label: 'GOOGLE',
                                onTap: () => ref
                                    .read(authNotifierProvider.notifier)
                                    .signInWithGoogle(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSocialButton(
                                icon: Icons.apple,
                                label: 'APPLE ID',
                                onTap: () => ref
                                    .read(authNotifierProvider.notifier)
                                    .signInWithApple(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (authState.isLoading)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                            color: AppColors.secondaryFixed,
                          ),
                        ),

                      // ── Pro Tip ───────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PRO TIP',
                                    style: GoogleFonts.lexend(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ensure your squad credentials are secure. Champions never leave their goal undefended.',
                                    style: GoogleFonts.lexend(
                                      fontSize: 12,
                                      color: AppColors.onPrimaryContainer,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Error
                      if (authState.hasError) ...[
                        const SizedBox(height: 16),
                        _buildErrorCard(authState.error!),
                      ],

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.onSurface.withOpacity(0.7)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface.withOpacity(0.7),
              ),
            ),
            if (label == 'PASSWORD') ...[
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'FORGOT?',
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryFixed,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: GoogleFonts.lexend(
            fontSize: 16,
            color: AppColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: label == 'EMAIL ADDRESS'
                ? 'manager@futko.com'
                : label == 'PASSWORD'
                    ? '••••••••'
                    : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surfaceContainerHighest.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.outlineVariant.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.outlineVariant.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.secondaryFixed,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            hintStyle: GoogleFonts.lexend(
              fontSize: 16,
              color: AppColors.onSurfaceVariant.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKickOffButton(AsyncValue authState) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.secondaryFixed, AppColors.onSecondaryContainer],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSecondaryFixedVariant.withOpacity(0.4),
              blurRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: authState.isLoading ? null : _submit,
            child: Center(
              child: authState.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.onSecondaryFixedVariant,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sports_soccer,
                          color: AppColors.onSecondaryFixedVariant,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _isSignUp ? 'CREATE SQUAD' : 'KICK OFF',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSecondaryFixedVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surfaceContainerHigh.withOpacity(0.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.outlineVariant.withOpacity(0.15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: label == 'GOOGLE'
                    ? AppColors.onSurface
                    : Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(Object error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ref.read(authNotifierProvider.notifier).getErrorMessage(error),
              style: GoogleFonts.lexend(
                fontSize: 13,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grass Painter ─────────────────────────────────────────
class _LoginGrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.02);
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
