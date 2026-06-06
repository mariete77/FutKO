import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static const String _apiKeyAndroid = String.fromEnvironment(
    'REVENUECAT_API_KEY_ANDROID',
    defaultValue: '',
  );
  static const String _apiKeyIos = String.fromEnvironment(
    'REVENUECAT_API_KEY_IOS',
    defaultValue: '',
  );

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    final apiKey = Platform.isAndroid ? _apiKeyAndroid : _apiKeyIos;
    if (apiKey.isEmpty) {
      throw Exception('RevenueCat API key not configured for current platform');
    }

    await Purchases.setLogLevel(LogLevel.debug);
    final configuration = PurchasesConfiguration(apiKey);
    await Purchases.configure(configuration);
    _initialized = true;
  }

  static Future<bool> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all['premium']?.isActive == true;
    } catch (e) {
      return false;
    }
  }

  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      return null;
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.all['premium']?.isActive == true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all['premium']?.isActive == true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> setUserId(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (e) {
      // Log error but don't crash
    }
  }
}
