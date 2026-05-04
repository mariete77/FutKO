import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/revenuecat_service.dart';
import '../../../providers/subscription_provider.dart';

class SubscriptionModal extends ConsumerStatefulWidget {
  const SubscriptionModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SubscriptionModal(),
    );
  }

  @override
  ConsumerState<SubscriptionModal> createState() => _SubscriptionModalState();
}

class _SubscriptionModalState extends ConsumerState<SubscriptionModal> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(subscriptionProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                color: AppColors.highlight.withOpacity(0.03),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 48),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MEMBRESÍA',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 4,
                          color: AppColors.tertiary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Afición\nÉlite',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                          height: 0.9,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Text(
                        'Lleva tu pasión futbolera al siguiente nivel con partidas ilimitadas y estadísticas exclusivas.',
                        style: GoogleFonts.workSans(
                          fontSize: 18,
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 56),

                      _buildBenefitItem(
                        icon: Icons.emoji_events_outlined,
                        title: 'Partidas Clasificatorias',
                        description: '5 batallas diarias para subir tu ELO.',
                      ),
                      const SizedBox(height: 24),
                      _buildBenefitItem(
                        icon: Icons.group_outlined,
                        title: 'Duelos con Amigos',
                        description: 'Partidas ilimitadas contra tus contactos.',
                      ),
                      const SizedBox(height: 24),
                      _buildBenefitItem(
                        icon: Icons.bolt_outlined,
                        title: 'Partidas Rápidas',
                        description: 'Entrenamiento sin límites diarios.',
                      ),
                      const SizedBox(height: 24),
                      _buildBenefitItem(
                        icon: Icons.auto_graph_outlined,
                        title: 'Estadísticas Avanzadas',
                        description: 'Gráficas de rendimiento y análisis detallado.',
                      ),

                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ambientShadow(opacity: 0.08),
                      blurRadius: 32,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL POR MES',
                              style: GoogleFonts.workSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '1.99€',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryContainer.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'MEJOR VALOR',
                            style: GoogleFonts.workSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (subState.status == SubscriptionStatus.loading)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      )
                    else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(9999),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9999),
                              onTap: subState.isPremium
                                  ? null
                                  : () => _purchase(context),
                              child: Center(
                                child: Text(
                                  subState.isPremium ? 'Ya eres Premium' : 'Suscribirse Ahora',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: subState.isPremium
                                        ? AppColors.onSurfaceVariant
                                        : AppColors.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => _restore(context),
                        child: Text(
                          'Restaurar compras',
                          style: GoogleFonts.workSans(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            top: 24,
            right: 24,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainerHigh.withOpacity(0.5),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 20),
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _purchase(BuildContext context) async {
    final notifier = ref.read(subscriptionProvider.notifier);
    final offerings = await RevenueCatService.getOfferings();
    if (offerings == null) return;

    final current = offerings.current;
    if (current == null) return;

    final package = current.monthly?.storeProduct != null
        ? current.monthly!
        : current.annual ?? current.lifetime ?? current.weekly!;

    final success = await notifier.purchasePackage(package);
    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Bienvenido a la élite!')),
      );
    }
  }

  Future<void> _restore(BuildContext context) async {
    final notifier = ref.read(subscriptionProvider.notifier);
    final success = await notifier.restorePurchases();
    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compras restauradas correctamente')),
      );
    }
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 24, color: AppColors.primary),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
