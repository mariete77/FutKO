import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futko/services/revenuecat_service.dart';

enum SubscriptionStatus { unknown, loading, free, premium, error }

class SubscriptionState {
  final SubscriptionStatus status;
  final String? errorMessage;

  const SubscriptionState({
    this.status = SubscriptionStatus.unknown,
    this.errorMessage,
  });

  bool get isPremium => status == SubscriptionStatus.premium;
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());

  Future<void> initialize() async {
    state = const SubscriptionState(status: SubscriptionStatus.loading);
    try {
      await RevenueCatService.initialize();
      final isPremium = await RevenueCatService.isPremium();
      state = SubscriptionState(
        status: isPremium ? SubscriptionStatus.premium : SubscriptionStatus.free,
      );
    } catch (e) {
      state = SubscriptionState(
        status: SubscriptionStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> purchasePackage(dynamic package) async {
    state = const SubscriptionState(status: SubscriptionStatus.loading);
    try {
      final success = await RevenueCatService.purchasePackage(package);
      state = SubscriptionState(
        status: success ? SubscriptionStatus.premium : SubscriptionStatus.free,
      );
      return success;
    } catch (e) {
      state = SubscriptionState(
        status: SubscriptionStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> restorePurchases() async {
    state = const SubscriptionState(status: SubscriptionStatus.loading);
    try {
      final success = await RevenueCatService.restorePurchases();
      state = SubscriptionState(
        status: success ? SubscriptionStatus.premium : SubscriptionStatus.free,
      );
      return success;
    } catch (e) {
      state = SubscriptionState(
        status: SubscriptionStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void setUserId(String userId) {
    RevenueCatService.setUserId(userId);
    initialize();
  }
}
