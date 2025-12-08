import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/coupon.dart';
import '../../../../shared/data/mock_data.dart';

/// Notifier pour les coupons
class CouponNotifier extends Notifier<List<Coupon>> {
  @override
  List<Coupon> build() {
    // Initialiser avec les coupons de démo
    return MockData.demoCoupons;
  }

  /// Obtenir les coupons valides
  List<Coupon> getValidCoupons() {
    return state.where((coupon) => coupon.isValid).toList();
  }

  /// Obtenir les coupons de l'utilisateur (utilisés et disponibles)
  List<Coupon> getUserCoupons() {
    // Pour l'instant, retourner tous les coupons valides
    // Dans une vraie app, on filtrerait par utilisateur
    return getValidCoupons();
  }

  /// Utiliser un coupon
  void useCoupon(String couponId) {
    state = state.map((coupon) {
      if (coupon.id == couponId) {
        return Coupon(
          id: coupon.id,
          code: coupon.code,
          description: coupon.description,
          discountType: coupon.discountType,
          discountValue: coupon.discountValue,
          validFrom: coupon.validFrom,
          validUntil: coupon.validUntil,
          minimumPurchase: coupon.minimumPurchase,
          maximumDiscount: coupon.maximumDiscount,
          usageLimit: coupon.usageLimit,
          usedCount: coupon.usedCount + 1,
          isActive: coupon.isActive,
        );
      }
      return coupon;
    }).toList();
  }
}

/// Provider pour les coupons
final couponProvider = NotifierProvider<CouponNotifier, List<Coupon>>(
  () => CouponNotifier(),
);

/// Provider pour les coupons valides
final validCouponsProvider = Provider<List<Coupon>>((ref) {
  final coupons = ref.watch(couponProvider);
  return coupons.where((coupon) => coupon.isValid).toList();
});

/// Provider pour les coupons de l'utilisateur
final userCouponsProvider = Provider<List<Coupon>>((ref) {
  final coupons = ref.watch(couponProvider);
  return coupons.where((coupon) => coupon.isValid).toList();
});

