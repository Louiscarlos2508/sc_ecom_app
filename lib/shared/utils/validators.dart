/// Utilitaires de validation pour ECONOMAX
class Validators {
  Validators._();

  /// Valider un email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  /// Valider un numéro de téléphone burkinabè
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    // Format burkinabè : +226 XX XX XX XX ou 0X XX XX XX XX
    final phoneRegex = RegExp(r'^(\+226|0)[0-9]{8,9}$');
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Numéro de téléphone invalide (format: +226 XX XX XX XX)';
    }
    return null;
  }

  /// Valider un mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  /// Valider la confirmation du mot de passe
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  /// Valider un nom
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom est requis';
    }
    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
  }

  /// Valider une ville
  static String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'La ville est requise';
    }
    final validCities = [
      'Ouagadougou',
      'Bobo-Dioulasso',
      'Koudougou',
      'Ouahigouya',
      'Banfora',
      'Dédougou',
      'Kaya',
      'Tenkodogo',
      'Fada N\'gourma',
      'Dori',
    ];
    if (!validCities.contains(value)) {
      return 'Ville non reconnue';
    }
    return null;
  }

  /// Valider un code de parrainage
  static String? validateReferralCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le code de parrainage est obligatoire';
    }
    if (value.length < 4) {
      return 'Code de parrainage invalide';
    }
    return null;
  }

  /// Valider un prix en FCFA
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prix est requis';
    }
    final price = int.tryParse(value);
    if (price == null || price <= 0) {
      return 'Prix invalide (doit être un nombre positif)';
    }
    if (price < 100) {
      return 'Le prix minimum est de 100 FCFA';
    }
    return null;
  }

  /// Valider une description de produit
  static String? validateProductDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'La description est requise';
    }
    if (value.length < 10) {
      return 'La description doit contenir au moins 10 caractères';
    }
    if (value.length > 1000) {
      return 'La description ne doit pas dépasser 1000 caractères';
    }
    return null;
  }

  /// Valider un nom de produit
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom du produit est requis';
    }
    if (value.length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }
    if (value.length > 100) {
      return 'Le nom ne doit pas dépasser 100 caractères';
    }
    return null;
  }

  /// Valider une adresse de livraison
  static String? validateDeliveryAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'adresse de livraison est requise';
    }
    if (value.length < 10) {
      return 'L\'adresse doit contenir au moins 10 caractères';
    }
    return null;
  }

  /// Valider un commentaire
  static String? validateComment(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le commentaire est requis';
    }
    if (value.length < 5) {
      return 'Le commentaire doit contenir au moins 5 caractères';
    }
    if (value.length > 500) {
      return 'Le commentaire ne doit pas dépasser 500 caractères';
    }
    return null;
  }

  /// Valider une note (rating)
  static String? validateRating(int? value) {
    if (value == null) {
      return 'La note est requise';
    }
    if (value < 1 || value > 5) {
      return 'La note doit être entre 1 et 5';
    }
    return null;
  }
}

