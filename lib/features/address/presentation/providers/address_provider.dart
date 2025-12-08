import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/delivery_address.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Notifier pour les adresses de livraison
class AddressNotifier extends Notifier<List<DeliveryAddress>> {
  @override
  List<DeliveryAddress> build() {
    // Initialiser avec une liste vide
    return <DeliveryAddress>[];
  }

  /// Ajouter une nouvelle adresse
  void addAddress(DeliveryAddress address) {
    final newAddresses = [...state];
    
    // Si c'est l'adresse par défaut, retirer le statut par défaut des autres
    if (address.isDefault) {
      newAddresses.forEach((addr) {
        if (addr.isDefault) {
          newAddresses[newAddresses.indexOf(addr)] = addr.copyWith(isDefault: false);
        }
      });
    }
    
    newAddresses.add(address);
    state = newAddresses;
  }

  /// Mettre à jour une adresse
  void updateAddress(DeliveryAddress address) {
    final newAddresses = state.map((addr) {
      if (addr.id == address.id) {
        return address;
      }
      // Si c'est la nouvelle adresse par défaut, retirer le statut des autres
      if (address.isDefault && addr.isDefault && addr.id != address.id) {
        return addr.copyWith(isDefault: false);
      }
      return addr;
    }).toList();
    
    state = newAddresses;
  }

  /// Supprimer une adresse
  void deleteAddress(String addressId) {
    state = state.where((addr) => addr.id != addressId).toList();
  }

  /// Définir une adresse comme par défaut
  void setDefaultAddress(String addressId) {
    state = state.map((addr) {
      if (addr.id == addressId) {
        return addr.copyWith(isDefault: true);
      } else if (addr.isDefault) {
        return addr.copyWith(isDefault: false);
      }
      return addr;
    }).toList();
  }

  /// Obtenir l'adresse par défaut
  DeliveryAddress? getDefaultAddress() {
    try {
      return state.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return state.isNotEmpty ? state.first : null;
    }
  }
}

/// Provider pour les adresses
final addressProvider = NotifierProvider<AddressNotifier, List<DeliveryAddress>>(
  () => AddressNotifier(),
);

/// Provider pour les adresses de l'utilisateur connecté
final userAddressesProvider = Provider<List<DeliveryAddress>>((ref) {
  final user = ref.watch(currentUserProvider);
  final addresses = ref.watch(addressProvider);
  
  if (user == null) return [];
  
  return addresses.where((addr) => addr.userId == user.id).toList();
});

/// Provider pour l'adresse par défaut de l'utilisateur
final defaultAddressProvider = Provider<DeliveryAddress?>((ref) {
  final addresses = ref.watch(userAddressesProvider);
  
  try {
    return addresses.firstWhere((addr) => addr.isDefault);
  } catch (e) {
    return addresses.isNotEmpty ? addresses.first : null;
  }
});

