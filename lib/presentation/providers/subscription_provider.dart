import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futko/services/revenuecat_service.dart';
import 'package:futko/data/repositories/user_repository_impl.dart';

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
      if (success) {
        await _syncSubscriptionToFirestore(true);
      }
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
      if (success) {
        await _syncSubscriptionToFirestore(true);
      }
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

  Future<void> _syncSubscriptionToFirestore(bool isPremium) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final repo = UserRepositoryImpl();
    await repo.updateSubscription(
      user.uid,
      isPremium ? 'premium' : 'free',
      isPremium,
      null,
    );
  }
}
