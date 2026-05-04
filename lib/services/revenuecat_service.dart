import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY';

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    await Purchases.setLogLevel(LogLevel.debug);
    final configuration = PurchasesConfiguration(_apiKey);

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

  static void setApiKey(String apiKey) {
    // This is a no-op since API key is set at configure time
    // This method exists for future runtime configuration
  }
}
